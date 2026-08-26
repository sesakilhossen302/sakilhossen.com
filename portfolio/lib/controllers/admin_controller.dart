import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/portfolio_models.dart';
import '../models/project_model.dart';
import 'portfolio_controller.dart';

class AdminController extends GetxController {
  final String apiHost = PortfolioController.apiHost;
  
  final RxString token = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isLoadingInbox = false.obs;
  
  final RxList<ContactMessage> inboxMessages = <ContactMessage>[].obs;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token.value}',
  };

  Future<bool> login(String password) async {
    isSaving.value = true;
    try {
      final response = await http.post(
        Uri.parse('$apiHost/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': password}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token.value = data['token'] ?? '';
        isLoggedIn.value = true;
        
        // Load messages and current values
        fetchInbox();
        return true;
      }
    } catch (e) {
      print('Admin login error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  void logout() {
    token.value = '';
    isLoggedIn.value = false;
    inboxMessages.clear();
  }

  Future<void> fetchInbox() async {
    if (!isLoggedIn.value) return;
    isLoadingInbox.value = true;
    try {
      final response = await http.get(
        Uri.parse('$apiHost/contact'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        inboxMessages.value = data.map((m) => ContactMessage.fromJson(m)).toList();
      }
    } catch (e) {
      print('Fetch inbox messages error: $e');
    } finally {
      isLoadingInbox.value = false;
    }
  }

  Future<bool> deleteInboxMessage(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiHost/contact/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        inboxMessages.removeWhere((m) => m.id == id);
        return true;
      }
    } catch (e) {
      print('Delete message error: $e');
    }
    return false;
  }

  // --- CRUD API METHODS ---

  Future<bool> updateProfile(Profile profile) async {
    isSaving.value = true;
    try {
      if (Get.isRegistered<PortfolioController>()) {
        Get.find<PortfolioController>().profile.value = profile;
      }
      final response = await http.put(
        Uri.parse('$apiHost/portfolio/profile'),
        headers: headers,
        body: json.encode(profile.toJson()),
      ).timeout(const Duration(seconds: 180));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData(isSilent: true);
        return true;
      } else {
        print('Update profile HTTP error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Update profile error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  // Project CRUD
  Future<bool> addProject(Project project) async {
    isSaving.value = true;
    try {
      final response = await http.post(
        Uri.parse('$apiHost/projects'),
        headers: headers,
        body: json.encode(project.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Add project error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateProject(Project project) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/projects/${project.id}'),
        headers: headers,
        body: json.encode(project.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update project error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> deleteProject(String id) async {
    isSaving.value = true;
    try {
      final response = await http.delete(
        Uri.parse('$apiHost/projects/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Delete project error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  // Testimonials/References CRUD
  Future<bool> addReference(ClientReference ref) async {
    isSaving.value = true;
    try {
      final response = await http.post(
        Uri.parse('$apiHost/references'),
        headers: headers,
        body: json.encode(ref.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Add reference error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateReference(ClientReference ref) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/references/${ref.id}'),
        headers: headers,
        body: json.encode(ref.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update reference error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> deleteReference(String id) async {
    isSaving.value = true;
    try {
      final response = await http.delete(
        Uri.parse('$apiHost/references/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Delete reference error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  // Skills and Experience list updates
  Future<bool> updateSkills(List<SkillCategory> skillsList) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/skills'),
        headers: headers,
        body: json.encode({
          'skills': skillsList.map((s) => s.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update skills error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateExperience(List<Experience> expList) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/experience'),
        headers: headers,
        body: json.encode({
          'experience': expList.map((e) => e.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update experience error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateEducation(List<Education> eduList) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/education'),
        headers: headers,
        body: json.encode({
          'education': eduList.map((e) => e.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update education error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateAiWorkflow(List<AiWorkflowPoint> aiList) async {
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiHost/ai'),
        headers: headers,
        body: json.encode({
          'aiWorkflow': aiList.map((e) => e.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        Get.find<PortfolioController>().fetchPortfolioData();
        return true;
      }
    } catch (e) {
      print('Update AI workflow error: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }
}
