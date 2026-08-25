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

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    // Monitor scroll changes to update active section index
    scrollController.addListener(_onScroll);
    // Poll the backend for live updates every 15 seconds silently
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      fetchPortfolioData(isSilent: true);
    });
  }

  Future<void> _initializeData() async {
    // 1. Try loading cached live data first for instant UI response
    bool hasCache = await _loadFromCache();

    if (hasCache) {
      // Cached real data is displayed immediately; update silently in background
      isLoading.value = false;
      fetchPortfolioData(isSilent: true);
    } else {
      // No cache found. Keep loading indicator active while fetching from network
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

  @override
  void onClose() {
    _pollingTimer?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
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
      // Only fall back to offline data if network requests failed AND no cached data is present
      _loadOfflineFallback();
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

  // Offline Fallback Data
  void _loadOfflineFallback() {
    final fallback = {
      "profile": {
        "name": "Sakil Hossen (Offline)",
        "title": "Flutter Mobile Application Developer",
        "tagline": "Available for Hire & Projects",
        "bio": "I am a passionate Flutter Developer based in Bangladesh, specializing in crafting premium mobile and web applications. With expertise in Dart and cross-platform architecture, I transform ideas into seamless, fully-functional, and responsive digital experiences.",
        "cvUrl": "https://github.com/sakil",
        "experienceYears": "3+",
        "completedProjects": "20+",
        "happyClients": "10+",
        "developmentPhilosophy": "I place a strong emphasis on clean code architecture (like Clean Architecture or MVC/MVVM), pixel-perfect UI designs, interactive animations, and stellar app performance. Whether it is a web platform, a mobile utility, or an API integration, I strive for excellence in every project.",
        "careerGoals": "To build scalable, robust mobile apps that run globally and collaborate in high-performing international teams.",
        "phone": "+880 1700-000000",
        "profileImage": "",
        "email": "sakil@example.com",
        "location": "Dhaka, Bangladesh"
      },

      "projects": [
        {
          "id": "proj-1",
          "title": "Quran International",
          "description": "A multilingual Quran application designed to bring the holy book to a global audience. It features dynamic script scaling, offline audio recitations, bookmarks, translations, and robust searching, built with clean architecture.",
          "image": "assets/images/quran_international.png",
          "playStoreUrl": "https://play.google.com/store/apps",
          "appStoreUrl": "https://apps.apple.com/app",
          "githubUrl": "https://github.com/sakil/quran-international",
          "tags": ["Flutter", "Dart", "Clean Architecture", "SQLite", "Audio Player"],
          "features": [
            "Multilingual Translation Support (English, Bengali, Urdu, Spanish, etc.)",
            "Offline Audio Recitation with verse-by-verse highlight syncing",
            "Advanced bookmarking, indexing, and notes system",
            "ATS-friendly clean, modern, readable typography settings"
          ]
        },
        {
          "id": "proj-2",
          "title": "Live Stream App",
          "description": "A high-performance live video streaming application with real-time comments, live reactions, audience interactions, and payment support. Built to handle low latency stream connections.",
          "image": "assets/images/live_stream.png",
          "playStoreUrl": "https://play.google.com/store/apps",
          "appStoreUrl": "",
          "githubUrl": "https://github.com/sakil/live-stream-app",
          "tags": ["Flutter", "WebRTC", "Agora SDK", "WebSocket", "Node.js"],
          "features": [
            "Ultra-low latency live video streaming with Agora SDK integration",
            "Real-time chat feed with floating hearts and custom emoji animations",
            "Virtual gifting and in-app purchase token system",
            "Co-hosting and split-screen video capability"
          ]
        },
        {
          "id": "proj-3",
          "title": "Restaurant Booking System",
          "description": "A premium table booking and reservation management system for restaurants. Features visual table mapping, menu pre-ordering, custom notifications, and interactive scheduling.",
          "image": "assets/images/restaurant_booking.png",
          "playStoreUrl": "",
          "appStoreUrl": "https://apps.apple.com/app",
          "githubUrl": "https://github.com/sakil/restaurant-booking",
          "tags": ["Flutter Web", "REST API", "State Management", "Google Maps"],
          "features": [
            "Interactive floor plan for selecting specific tables visually",
            "Seamless reservation scheduling with calendar and push notification reminders",
            "Pre-order meals directly from the digital menu during booking",
            "Admin control panel for managers to manage bookings and menus"
          ]
        },
        {
          "id": "proj-4",
          "title": "Job Booking System",
          "description": "A comprehensive marketplace app connecting service providers with clients. Features scheduling, Stripe payments, real-time tracking of providers, and in-app push alerts.",
          "image": "assets/images/job_booking.png",
          "playStoreUrl": "https://play.google.com/store/apps",
          "appStoreUrl": "https://apps.apple.com/app",
          "githubUrl": "",
          "tags": ["Flutter", "Firebase", "Stripe Payment", "Push Notifications", "Dio"],
          "features": [
            "On-demand job scheduling with auto-matching algorithms",
            "Integrated secure payments via Stripe and Apple/Google Pay",
            "Real-time technician location tracking on interactive maps",
            "Built-in rating and reviews system for quality assurance"
          ]
        }
      ],
      "skills": [
        {
          "category": "Mobile Development",
          "items": ["Flutter", "Dart", "Android", "iOS"]
        },
        {
          "category": "State Management",
          "items": ["GetX", "Provider"]
        },
        {
          "category": "Backend Integration",
          "items": ["REST API", "Firebase", "Dio", "HTTP"]
        },
        {
          "category": "Payments",
          "items": ["Stripe", "Google Pay", "Apple Pay", "In-App Purchase"]
        },
        {
          "category": "Real-Time Systems",
          "items": ["WebSocket", "Live Chat", "Push Notifications"]
        },
        {
          "category": "Developer Tools",
          "items": ["Git", "GitHub", "Postman", "Android Studio", "VS Code"]
        },
        {
          "category": "AI Productivity",
          "items": ["Prompt Engineering", "ChatGPT", "Gemini", "Claude", "AI Workflow Optimization"]
        }
      ],
      "experience": [
        {
          "id": "exp-1",
          "role": "Flutter Mobile Application Developer",
          "company": "SparkTech Agency",
          "duration": "2023 - Present",
          "achievements": [
            "Delivered 9+ premium production-ready mobile applications to global clients",
            "Integrated complex payment gateways (Stripe, Google Pay, Apple Pay) in Flutter apps",
            "Developed low-latency real-time systems using WebSockets, Agora, and Push Notifications",
            "Collaborated with international developers and designers in remote agile environments",
            "Managed successful production deployments to Google Play Store and Apple App Store"
          ]
        }
      ],
      "education": [
        {
          "id": "edu-1",
          "institution": "TMSS Polytechnic Institute",
          "degree": "Diploma in Computer Science & Technology",
          "duration": "2019 - 2023",
          "details": "Focused on computer systems, database design, data structures, and core software engineering concepts."
        },
        {
          "id": "edu-2",
          "institution": "BD Calling Academy",
          "degree": "Flutter App Development Training",
          "duration": "2023 (6 Months)",
          "details": "Intensive hands-on training in cross-platform mobile architecture, state management, and real-world project deployments."
        }
      ],
      "references": [
        {
          "id": "ref-1",
          "clientName": "Sarah Jenkins",
          "clientCompany": "Product Director, TechNova",
          "clientComment": "Sakil is an exceptional Flutter developer. He delivered our cross-platform MVP two weeks ahead of schedule. The animations are incredibly smooth and the code is very easy to read. Highly recommended!",
          "clientRating": 5.0,
          "clientImage": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150"
        },
        {
          "id": "ref-2",
          "clientName": "Alex Rivera",
          "clientCompany": "Founder, Vibez Streaming",
          "clientComment": "Working with Sakil Hossen was a great experience. He helped us resolve major audio sync and performance issues in our app. His understanding of WebRTC and WebSockets is outstanding.",
          "clientRating": 4.9,
          "clientImage": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150"
        }
      ],
      "aiWorkflow": [
        {
          "title": "AI-Assisted Development",
          "description": "Utilizing advanced code generation tools to write boilerplate, speed up syntax declarations, and improve software delivery timeframes.",
          "icon": "code"
        },
        {
          "title": "Prompt Engineering",
          "description": "Formulating detailed, contextual prompts to extract high-quality code structures, solutions to algorithms, and mock dataset configurations.",
          "icon": "psychology"
        },
        {
          "title": "Rapid Prototyping",
          "description": "Spawning mock application mockups, state models, and JSON API payloads swiftly to demonstrate project feasibility in record time.",
          "icon": "bolt"
        },
        {
          "title": "Requirement Analysis",
          "description": "Summarizing lengthy software specifications and user stories to map architectural diagrams and draft precise database models.",
          "icon": "analytics"
        },
        {
          "title": "Development Productivity",
          "description": "Streamlining IDE setup workflows, script automation, and linter debugging to maintain optimal concentration on business logic coding.",
          "icon": "auto_awesome"
        },
        {
          "title": "AI-Powered Debugging",
          "description": "Analyzing stack traces and memory leaks with intelligent search queries to troubleshoot issues across multi-threaded operations quickly.",
          "icon": "bug_report"
        }
      ]
    };
    _parseData(fallback);
  }
}
