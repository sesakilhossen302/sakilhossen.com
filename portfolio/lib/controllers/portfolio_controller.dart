import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_models.dart';
import '../models/project_model.dart';
import '../theme/portfolio_theme.dart';

class PortfolioController extends GetxController {
  static const String apiHost = 'https://global-standard-portfolio-website-backend.onrender.com/api';
  static const String _cacheKey = 'cached_portfolio_data_v1';

  // Observable portfolio data
  final Rxn<Profile> profile = Rxn<Profile>();
  final RxList<Project> projects = <Project>[].obs;
  final RxList<SkillCategory> skills = <SkillCategory>[].obs;
  final RxList<Experience> experience = <Experience>[].obs;
  final RxList<Education> education = <Education>[].obs;
  final RxList<AiWorkflowPoint> aiWorkflow = <AiWorkflowPoint>[].obs;
  final RxList<ClientReference> references = <ClientReference>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isDarkMode = true.obs;

  // Active section for Navbar highlighting
  final RxInt activeSectionIndex = 0.obs;

  // GlobalKeys for scroll sections (10 sections)
  final List<GlobalKey> sectionKeys = List.generate(10, (index) => GlobalKey());
  final ScrollController scrollController = ScrollController();
  Timer? _pollingTimer;
  http.Client? _sseClient;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    // Monitor scroll changes to update active section index
    scrollController.addListener(_onScroll);
    // Poll backend every 5 seconds for fast updates
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchPortfolioData(isSilent: true);
    });
    // Establish real-time SSE listener for 0-second multi-device sync
    _listenToRealtimeEvents();
  }

  void _listenToRealtimeEvents() async {
    try {
      _sseClient?.close();
      _sseClient = http.Client();
      final request = http.Request('GET', Uri.parse('$apiHost/events'));
      final response = await _sseClient!.send(request);

      response.stream.transform(utf8.decoder).listen((data) {
        if (data.contains('portfolio_updated')) {
          fetchPortfolioData(isSilent: true);
        }
      }, onError: (e) {
        print('SSE stream error: $e');
      });
    } catch (e) {
      print('Failed to connect to real-time events SSE stream: $e');
    }
  }

  @override
  void onClose() {
    _sseClient?.close();
    _pollingTimer?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    // 1. Try loading cached live data first for instant UI response
    bool hasCache = await _loadFromCache();

    if (hasCache) {
      // Cached real data is displayed immediately; update silently in background
      isLoading.value = false;
      fetchPortfolioData(isSilent: true);
    } else {
      // No cache found. Keep loading indicator active while fetching 100% dynamic data from API
      isLoading.value = true;
      await fetchPortfolioData(isSilent: false);
    }
  }

  Future<bool> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(_cacheKey);
      if (cachedString != null && cachedString.isNotEmpty) {
        final data = json.decode(cachedString);
        _parseData(data);
        return true;
      }
    } catch (e) {
      print('Error loading cached portfolio data: $e');
    }
    return false;
  }

  Future<void> _saveToCache(String rawJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, rawJson);
    } catch (e) {
      print('Error saving portfolio cache: $e');
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? PortfolioTheme.darkTheme : PortfolioTheme.lightTheme);
  }

  // Scroll to section by index
  void scrollToSection(int index) {
    activeSectionIndex.value = index;
    final key = sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onScroll() {
    // Detect which section is currently centered on the screen
    double screenCenter = scrollController.offset + (Get.height / 3);
    
    for (int i = 9; i >= 0; i--) {
      final key = sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final globalOffset = position.dy + scrollController.offset;
          if (screenCenter >= globalOffset) {
            activeSectionIndex.value = i;
            break;
          }
        }
      }
    }
  }

  // Fetch portfolio data from Node.js with retries and extended Render cold-start timeout
  Future<void> fetchPortfolioData({bool isSilent = false}) async {
    if (!isSilent && profile.value == null) {
      isLoading.value = true;
    }

    int maxAttempts = 3;
    bool success = false;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await http.get(Uri.parse('$apiHost/portfolio')).timeout(
          const Duration(seconds: 15), // Extended to 15s to allow Render free tier cold-start
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _parseData(data);
          _saveToCache(response.body);
          success = true;
          break; // Exit loop on successful fetch
        }
      } catch (e) {
        print('Fetch portfolio data attempt $attempt/$maxAttempts failed: $e');
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    if (!success && profile.value == null && !isSilent) {
      print('Failed to fetch live portfolio data from backend API');
    }

    if (!isSilent) {
      isLoading.value = false;
    }
  }


  void _parseData(Map<String, dynamic> data) {
    if (data['profile'] != null) {
      profile.value = Profile.fromJson(data['profile']);
    }

    if (data['projects'] != null) {
      projects.value = (data['projects'] as List)
          .map((p) => Project.fromJson(p))
          .toList();
    }

    if (data['skills'] != null) {
      skills.value = (data['skills'] as List)
          .map((s) => SkillCategory.fromJson(s))
          .toList();
    }

    if (data['experience'] != null) {
      experience.value = (data['experience'] as List)
          .map((e) => Experience.fromJson(e))
          .toList();
    }

    if (data['education'] != null) {
      education.value = (data['education'] as List)
          .map((edu) => Education.fromJson(edu))
          .toList();
    }

    if (data['references'] != null) {
      references.value = (data['references'] as List)
          .map((r) => ClientReference.fromJson(r))
          .toList();
    }
    if (data['aiWorkflow'] != null) {
      aiWorkflow.value = (data['aiWorkflow'] as List)
          .map((a) => AiWorkflowPoint.fromJson(a))
          .toList();
    }
  }

  // Submit contact form to server
  Future<bool> sendContactMessage(String name, String email, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$apiHost/contact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'message': message,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('Failed to send contact message: $e');
    }
    return false;
  }
}
