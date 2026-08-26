import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../models/project_model.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/portfolio_image.dart';
import '../widgets/image_picker_helper.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final adminController = Get.find<AdminController>();
  final portfolioController = Get.find<PortfolioController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Redirect if not logged in
      if (!adminController.isLoggedIn.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed('/admin');
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final isDark = portfolioController.isDarkMode.value;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? PortfolioTheme.surfaceDark : Colors.white,
          elevation: 1,
          title: Row(
            children: [
              Text(
                "Sakil Hossen",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : PortfolioTheme.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PortfolioTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Dashboard",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: PortfolioTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.yellowAccent : PortfolioTheme.secondary,
              ),
              onPressed: portfolioController.toggleTheme,
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.logout_rounded, size: 16),
              label: const Text("Logout"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              onPressed: () {
                adminController.logout();
                Get.offNamed('/');
              },
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: PortfolioTheme.primary,
            unselectedLabelColor: isDark ? Colors.white70 : Colors.black87,
            indicatorColor: PortfolioTheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.mail_outline_rounded), text: "Inbox Messages"),
              Tab(icon: Icon(Icons.person_outline_rounded), text: "Edit Profile"),
              Tab(icon: Icon(Icons.folder_copy_outlined), text: "Manage Projects"),
              Tab(icon: Icon(Icons.star_outline_rounded), text: "Manage Reviews"),
              Tab(icon: Icon(Icons.school_outlined), text: "Education"),
              Tab(icon: Icon(Icons.work_outline_rounded), text: "Work Experience"),
              Tab(icon: Icon(Icons.psychology_outlined), text: "Skills"),
              Tab(icon: Icon(Icons.auto_awesome_outlined), text: "AI Workflow"),
            ],
          ),
        ),
        body: Container(
          color: isDark ? PortfolioTheme.bgDark : PortfolioTheme.bgLight,
          child: TabBarView(
            controller: _tabController,
            children: [
              _InboxTab(isDark: isDark),
              _ProfileTab(isDark: isDark),
              _ProjectsTab(isDark: isDark),
              _ReviewsTab(isDark: isDark),
              _EducationTab(isDark: isDark),
              _ExperienceTab(isDark: isDark),
              _SkillsTab(isDark: isDark),
              _AiWorkflowTab(isDark: isDark),
            ],
          ),
        ),
      );
    });
  }
}

// =======================
// 1. INBOX MESSAGES TAB
// =======================
class _InboxTab extends StatelessWidget {
  final bool isDark;
  const _InboxTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Obx(() {
      final messages = adminController.inboxMessages;
      final loading = adminController.isLoadingInbox.value;

      if (loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail_outline_rounded, size: 48, color: isDark ? Colors.white38 : Colors.black38),
              const SizedBox(height: 16),
              Text(
                "Your inbox is empty",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Refresh Inbox"),
                onPressed: adminController.fetchInbox,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: adminController.fetchInbox,
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: PortfolioTheme.primary.withOpacity(0.1),
                  child: const Icon(Icons.person_rounded, color: PortfolioTheme.primary),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      msg.name,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      msg.timestamp.substring(0, 10),
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      msg.email,
                      style: GoogleFonts.inter(color: PortfolioTheme.accent, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      msg.message,
                      style: GoogleFonts.inter(height: 1.4),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () => _confirmDeleteMessage(context, msg.id),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _confirmDeleteMessage(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Message"),
        content: const Text("Are you sure you want to delete this contact message permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteInboxMessage(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

// =======================
// 2. EDIT PROFILE DETAILS TAB
// =======================
class _ProfileTab extends StatefulWidget {
  final bool isDark;
  const _ProfileTab({required this.isDark});

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _taglineCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _cvUrlCtrl;
  late TextEditingController _expYearsCtrl;
  late TextEditingController _completedProjCtrl;
  late TextEditingController _clientsCtrl;
  late TextEditingController _philosophyCtrl;
  late TextEditingController _goalsCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _githubUrlCtrl;
  late TextEditingController _linkedinUrlCtrl;
  late TextEditingController _newPasswordCtrl;
  bool _isPasswordVisible = false;
  final List<TextEditingController> _heroVideoCtrls = [];
  String _profileImage = '';
  Map<String, String> _initialProfileMap = {};

  @override
  void initState() {
    super.initState();
    final profile = Get.find<PortfolioController>().profile.value;
    
    _nameCtrl = TextEditingController(text: profile?.name ?? '');
    _titleCtrl = TextEditingController(text: profile?.title ?? '');
    _taglineCtrl = TextEditingController(text: profile?.tagline ?? '');
    _bioCtrl = TextEditingController(text: profile?.bio ?? '');
    _cvUrlCtrl = TextEditingController(text: profile?.cvUrl ?? '');
    _expYearsCtrl = TextEditingController(text: profile?.experienceYears ?? '');
    _completedProjCtrl = TextEditingController(text: profile?.completedProjects ?? '');
    _clientsCtrl = TextEditingController(text: profile?.happyClients ?? '');
    _philosophyCtrl = TextEditingController(text: profile?.developmentPhilosophy ?? '');
    _goalsCtrl = TextEditingController(text: profile?.careerGoals ?? '');
    _phoneCtrl = TextEditingController(text: profile?.phone ?? '');
    _emailCtrl = TextEditingController(text: profile?.email ?? '');
    _locationCtrl = TextEditingController(text: profile?.location ?? '');
    _githubUrlCtrl = TextEditingController(text: profile?.githubUrl ?? '');
    _linkedinUrlCtrl = TextEditingController(text: profile?.linkedinUrl ?? '');
    _newPasswordCtrl = TextEditingController();

    _initVideoControllers(profile?.heroVideoUrl ?? '');
    _profileImage = profile?.profileImage ?? '';
    _snapshotInitialData(profile);
  }

  void _snapshotInitialData(Profile? p) {
    _initialProfileMap = {
      'name': p?.name ?? '',
      'title': p?.title ?? '',
      'tagline': p?.tagline ?? '',
      'bio': p?.bio ?? '',
      'cvUrl': p?.cvUrl ?? '',
      'experienceYears': p?.experienceYears ?? '',
      'completedProjects': p?.completedProjects ?? '',
      'happyClients': p?.happyClients ?? '',
      'developmentPhilosophy': p?.developmentPhilosophy ?? '',
      'careerGoals': p?.careerGoals ?? '',
      'phone': p?.phone ?? '',
      'email': p?.email ?? '',
      'location': p?.location ?? '',
      'githubUrl': p?.githubUrl ?? '',
      'linkedinUrl': p?.linkedinUrl ?? '',
      'heroVideoUrl': p?.heroVideoUrl ?? '',
      'profileImage': p?.profileImage ?? '',
    };
  }

  void _initVideoControllers(String rawUrl) {
    for (var c in _heroVideoCtrls) {
      c.dispose();
    }
    _heroVideoCtrls.clear();

    final links = rawUrl
        .split(RegExp(r'[\n,;]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (links.isEmpty) {
      _heroVideoCtrls.add(TextEditingController(text: ''));
    } else {
      for (var link in links) {
        _heroVideoCtrls.add(TextEditingController(text: link));
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _bioCtrl.dispose();
    _cvUrlCtrl.dispose();
    _expYearsCtrl.dispose();
    _completedProjCtrl.dispose();
    _clientsCtrl.dispose();
    _philosophyCtrl.dispose();
    _goalsCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _githubUrlCtrl.dispose();
    _linkedinUrlCtrl.dispose();
    _newPasswordCtrl.dispose();
    for (var c in _heroVideoCtrls) {
      c.dispose();
    }
    _heroVideoCtrls.clear();
    super.dispose();
  }

  void _addNewVideoField() {
    setState(() {
      _heroVideoCtrls.add(TextEditingController(text: ''));
    });
  }

  void _confirmDeleteVideoField(int index) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
            const SizedBox(width: 10),
            Text("Delete Video Link?", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(
          "Are you sure you want to remove Video #${index + 1} from your background playlist?",
          style: GoogleFonts.inter(color: const Color(0xFFCBD5E1), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.outfit(color: Colors.grey[400])),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever_rounded, size: 18),
            label: const Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Get.back();
              setState(() {
                _heroVideoCtrls[index].dispose();
                _heroVideoCtrls.removeAt(index);
                if (_heroVideoCtrls.isEmpty) {
                  _heroVideoCtrls.add(TextEditingController(text: ''));
                }
              });
              _saveProfile();
            },
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final currentJoinedVideoUrls = _heroVideoCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .join('\n');

    final Map<String, dynamic> currentFormValues = {
      'name': _nameCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'tagline': _taglineCtrl.text.trim(),
      'bio': _bioCtrl.text.trim(),
      'cvUrl': _cvUrlCtrl.text.trim(),
      'experienceYears': _expYearsCtrl.text.trim(),
      'completedProjects': _completedProjCtrl.text.trim(),
      'happyClients': _clientsCtrl.text.trim(),
      'developmentPhilosophy': _philosophyCtrl.text.trim(),
      'careerGoals': _goalsCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'githubUrl': _githubUrlCtrl.text.trim(),
      'linkedinUrl': _linkedinUrlCtrl.text.trim(),
      'heroVideoUrl': currentJoinedVideoUrls,
    };

    if (_profileImage.isNotEmpty) {
      currentFormValues['profileImage'] = _profileImage;
    }

    final Map<String, dynamic> changedFields = {};
    currentFormValues.forEach((key, value) {
      if (_initialProfileMap[key] != value) {
        changedFields[key] = value;
      }
    });

    if (changedFields.isEmpty) {
      Get.snackbar('Info', 'No changes detected to save.', backgroundColor: Colors.blueAccent, colorText: Colors.white);
      return;
    }

    final success = await Get.find<AdminController>().updateProfileMap(changedFields);
    if (success) {
      final updatedP = Get.find<PortfolioController>().profile.value;
      _snapshotInitialData(updatedP);
      Get.snackbar('Success', 'Updated ${changedFields.keys.join(", ")} successfully', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to save changes. Please check server connection.', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Public Brand & Identity",
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: PortfolioTheme.primary.withOpacity(0.1),
                  child: ClipOval(
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: PortfolioImage(imageSource: _profileImage),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image_search_rounded),
                  label: const Text("Upload Profile Image"),
                  onPressed: () async {
                    final base64Image = await pickImageAsBase64();
                    if (base64Image != null) {
                      setState(() {
                        _profileImage = base64Image;
                      });
                    }
                  },
                ),
                if (_profileImage.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                    label: const Text("Remove", style: TextStyle(color: Colors.redAccent)),
                    onPressed: () {
                      setState(() {
                        _profileImage = '';
                      });
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: "Profession Title", prefixIcon: Icon(Icons.badge)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _taglineCtrl,
                    decoration: const InputDecoration(labelText: "Hero Status / Tagline", prefixIcon: Icon(Icons.announcement)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(labelText: "Location", prefixIcon: Icon(Icons.location_on)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _githubUrlCtrl,
                    decoration: const InputDecoration(labelText: "GitHub URL", prefixIcon: Icon(Icons.link)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _linkedinUrlCtrl,
                    decoration: const InputDecoration(labelText: "LinkedIn URL", prefixIcon: Icon(Icons.link)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            TextFormField(
              controller: _bioCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Biography Text", prefixIcon: Icon(Icons.history_edu)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cvUrlCtrl,
              decoration: const InputDecoration(labelText: "CV Download Link / URL", prefixIcon: Icon(Icons.download)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            // --- HERO BACKGROUND VIDEO PLAYLIST MANAGER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.video_library_rounded, color: PortfolioTheme.accent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Hero Background Videos Playlist",
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text("+ Add New Video URL"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _addNewVideoField,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _heroVideoCtrls.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: PortfolioTheme.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Video #${index + 1}",
                          style: GoogleFonts.outfit(color: PortfolioTheme.accent, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _heroVideoCtrls[index],
                          decoration: const InputDecoration(
                            hintText: "Paste Google Drive share link or direct MP4 URL",
                            prefixIcon: Icon(Icons.link_rounded),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                        tooltip: "Delete Video #${index + 1}",
                        onPressed: () => _confirmDeleteVideoField(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            
            Text(
              "Key Portfolio Stats",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expYearsCtrl,
                    decoration: const InputDecoration(labelText: "Experience (e.g. 1+)", prefixIcon: Icon(Icons.timeline)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _completedProjCtrl,
                    decoration: const InputDecoration(labelText: "Completed Projects (e.g. 20+)", prefixIcon: Icon(Icons.done_all)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _clientsCtrl,
                    decoration: const InputDecoration(labelText: "Happy Clients (e.g. 25+)", prefixIcon: Icon(Icons.people_outline)),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              "Philosophies & Objectives",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _philosophyCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Development Philosophy", prefixIcon: Icon(Icons.explore)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _goalsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: "Career Goals", prefixIcon: Icon(Icons.flag)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 36),
            const Divider(color: Colors.white12),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.shield_rounded, color: PortfolioTheme.accent, size: 24),
                const SizedBox(width: 10),
                Text(
                  "Admin Security & Password Settings",
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Initial default password is set to Sakil@302. Enter a new password below to update your login credentials in MongoDB.",
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newPasswordCtrl,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "New Admin Password",
                        hintText: "Enter new password (e.g. Sakil@302)",
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.security_rounded, size: 18),
                    label: const Text("Update Password"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      final newPass = _newPasswordCtrl.text.trim();
                      if (newPass.isEmpty) {
                        Get.snackbar('Error', 'Please enter a password', backgroundColor: Colors.redAccent, colorText: Colors.white);
                        return;
                      }
                      final success = await Get.find<AdminController>().changePassword(newPass);
                      if (success) {
                        _newPasswordCtrl.clear();
                        Get.snackbar('Success', 'Admin password updated successfully in MongoDB!', backgroundColor: Colors.green, colorText: Colors.white);
                      } else {
                        Get.snackbar('Error', 'Failed to update password', backgroundColor: Colors.redAccent, colorText: Colors.white);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Obx(() {
              final saving = Get.find<AdminController>().isSaving.value;
              return SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: saving ? null : _saveProfile,
                  icon: const Icon(Icons.save_rounded),
                  label: saving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                      : const Text("Save Details"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// =======================
// 3. PROJECTS CRUD TAB
// =======================
class _ProjectsTab extends StatelessWidget {
  final bool isDark;
  const _ProjectsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final projects = controller.projects;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Project Gallery",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: PortfolioTheme.primary, foregroundColor: Colors.white),
                  onPressed: () => _openProjectForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Project"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final proj = projects[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: PortfolioImage(imageSource: proj.image),
                        ),
                      ),
                      title: Text(proj.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text(proj.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openProjectForm(context, proj),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteProject(context, proj.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDeleteProject(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Project"),
        content: const Text("Are you sure you want to delete this project?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteProject(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openProjectForm(BuildContext context, Project? project) {
    final isEdit = project != null;
    
    final titleCtrl = TextEditingController(text: project?.title ?? '');
    final descCtrl = TextEditingController(text: project?.description ?? '');
    final imgCtrl = TextEditingController(text: project?.image ?? '');
    final playCtrl = TextEditingController(text: project?.playStoreUrl ?? '');
    final appCtrl = TextEditingController(text: project?.appStoreUrl ?? '');
    final gitCtrl = TextEditingController(text: project?.githubUrl ?? '');
    final tagsCtrl = TextEditingController(text: project?.tags.join(', ') ?? '');
    final featuresCtrl = TextEditingController(text: project?.features.join('\n') ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? "Edit Project" : "Add Project"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Project Title")),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "About / Description")),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imgCtrl,
                          decoration: const InputDecoration(
                            labelText: "Image (Asset path or Base64)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded),
                        tooltip: "Upload image file",
                        onPressed: () async {
                          final base64Image = await pickImageAsBase64();
                          if (base64Image != null) {
                            setDialogState(() {
                              imgCtrl.text = base64Image;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (imgCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: PortfolioImage(imageSource: imgCtrl.text),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(controller: playCtrl, decoration: const InputDecoration(labelText: "Google Play Store Link")),
                  const SizedBox(height: 12),
                  TextField(controller: appCtrl, decoration: const InputDecoration(labelText: "Apple App Store Link")),
                  const SizedBox(height: 12),
                  TextField(controller: gitCtrl, decoration: const InputDecoration(labelText: "GitHub Link")),
                  const SizedBox(height: 12),
                  TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: "Tags (comma-separated, e.g. Flutter, Dart)")),
                  const SizedBox(height: 12),
                  TextField(controller: featuresCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Key Features (one per line)")),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final newProj = Project(
                  id: isEdit ? project.id : 'proj-${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  image: imgCtrl.text.trim(),
                  playStoreUrl: playCtrl.text.trim(),
                  appStoreUrl: appCtrl.text.trim(),
                  githubUrl: gitCtrl.text.trim(),
                  tags: tagsCtrl.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
                  features: featuresCtrl.text.split('\n').map((f) => f.trim()).where((f) => f.isNotEmpty).toList(),
                );

                final admin = Get.find<AdminController>();
                bool success = false;
                if (isEdit) {
                  success = await admin.updateProject(newProj);
                } else {
                  success = await admin.addProject(newProj);
                }

                if (success) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Project saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================
// 4. CLIENT REVIEWS CRUD TAB
// =======================
class _ReviewsTab extends StatelessWidget {
  final bool isDark;
  const _ReviewsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final reviews = controller.references;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Client Testimonials",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: PortfolioTheme.primary, foregroundColor: Colors.white),
                  onPressed: () => _openReviewForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Review"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final ref = reviews[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        child: ClipOval(
                          child: PortfolioImage(imageSource: ref.clientImage),
                        ),
                      ),
                      title: Text(ref.clientName, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text("${ref.clientCompany} - Rating: ${ref.clientRating}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openReviewForm(context, ref),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteReview(context, ref.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDeleteReview(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Review"),
        content: const Text("Are you sure you want to delete this recommendation permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteReference(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openReviewForm(BuildContext context, ClientReference? ref) {
    final isEdit = ref != null;
    
    final nameCtrl = TextEditingController(text: ref?.clientName ?? '');
    final compCtrl = TextEditingController(text: ref?.clientCompany ?? '');
    final commentCtrl = TextEditingController(text: ref?.clientComment ?? '');
    final ratingCtrl = TextEditingController(text: ref?.clientRating.toString() ?? '5.0');
    final imgCtrl = TextEditingController(text: ref?.clientImage ?? '');
    final screenshotCtrl = TextEditingController(text: ref?.reviewImage ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? "Edit Client Review" : "Add Client Review"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Client Name")),
                  const SizedBox(height: 12),
                  TextField(controller: compCtrl, decoration: const InputDecoration(labelText: "Company / Role")),
                  const SizedBox(height: 12),
                  TextField(controller: commentCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Review Comment")),
                  const SizedBox(height: 12),
                  TextField(controller: ratingCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Rating (e.g. 5.0)")),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imgCtrl,
                          decoration: const InputDecoration(
                            labelText: "Client Photo (URL or Base64)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded),
                        tooltip: "Upload image file",
                        onPressed: () async {
                          final base64Image = await pickImageAsBase64();
                          if (base64Image != null) {
                            setDialogState(() {
                              imgCtrl.text = base64Image;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (imgCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: PortfolioImage(imageSource: imgCtrl.text),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: screenshotCtrl,
                          decoration: const InputDecoration(
                            labelText: "Fiverr Review Screenshot (URL or Base64)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded),
                        tooltip: "Upload screenshot file",
                        onPressed: () async {
                          final base64Image = await pickImageAsBase64();
                          if (base64Image != null) {
                            setDialogState(() {
                              screenshotCtrl.text = base64Image;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (screenshotCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: PortfolioImage(
                          imageSource: screenshotCtrl.text,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final newRef = ClientReference(
                  id: isEdit ? ref.id : 'ref-${DateTime.now().millisecondsSinceEpoch}',
                  clientName: nameCtrl.text.trim(),
                  clientCompany: compCtrl.text.trim(),
                  clientComment: commentCtrl.text.trim(),
                  clientRating: double.tryParse(ratingCtrl.text) ?? 5.0,
                  clientImage: imgCtrl.text.trim(),
                  reviewImage: screenshotCtrl.text.trim(),
                );

                final admin = Get.find<AdminController>();
                bool success = false;
                if (isEdit) {
                  success = await admin.updateReference(newRef);
                } else {
                  success = await admin.addReference(newRef);
                }

                if (success) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Recommendation saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================
// 5. EDUCATION TAB
// =======================
class _EducationTab extends StatelessWidget {
  final bool isDark;
  const _EducationTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final educationList = controller.education;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Education & Training",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _openEducationForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Education"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: educationList.length,
                itemBuilder: (context, index) {
                  final edu = educationList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(edu.institution, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text("${edu.degree} (${edu.duration})"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openEducationForm(context, edu),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Education Record"),
        content: const Text("Are you sure you want to delete this education entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<Education> newList = List.from(controller.education);
              newList.removeAt(index);
              final success = await admin.updateEducation(newList);
              Navigator.pop(context);
              if (success) {
                Get.snackbar('Success', 'Education entry deleted', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openEducationForm(BuildContext context, Education? edu) {
    final isEdit = edu != null;
    final instCtrl = TextEditingController(text: edu?.institution ?? '');
    final degCtrl = TextEditingController(text: edu?.degree ?? '');
    final durCtrl = TextEditingController(text: edu?.duration ?? '');
    final detCtrl = TextEditingController(text: edu?.details ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Education" : "Add Education"),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: instCtrl, decoration: const InputDecoration(labelText: "Institution")),
                const SizedBox(height: 12),
                TextField(controller: degCtrl, decoration: const InputDecoration(labelText: "Degree / Course")),
                const SizedBox(height: 12),
                TextField(controller: durCtrl, decoration: const InputDecoration(labelText: "Duration (e.g. 2019 - 2023)")),
                const SizedBox(height: 12),
                TextField(controller: detCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Details / Achievements")),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<Education> newList = List.from(controller.education);

              final newEdu = Education(
                id: isEdit ? edu.id : 'edu-${DateTime.now().millisecondsSinceEpoch}',
                institution: instCtrl.text.trim(),
                degree: degCtrl.text.trim(),
                duration: durCtrl.text.trim(),
                details: detCtrl.text.trim(),
              );

              if (isEdit) {
                final idx = newList.indexWhere((e) => e.id == edu.id);
                if (idx != -1) newList[idx] = newEdu;
              } else {
                newList.add(newEdu);
              }

              final success = await admin.updateEducation(newList);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Education saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

// =======================
// 6. WORK EXPERIENCE TAB
// =======================
class _ExperienceTab extends StatelessWidget {
  final bool isDark;
  const _ExperienceTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final experienceList = controller.experience;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Work Experience",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _openExperienceForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Experience"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: experienceList.length,
                itemBuilder: (context, index) {
                  final exp = experienceList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(exp.role, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text("${exp.company} (${exp.duration})"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openExperienceForm(context, exp),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Experience Record"),
        content: const Text("Are you sure you want to delete this experience entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<Experience> newList = List.from(controller.experience);
              newList.removeAt(index);
              final success = await admin.updateExperience(newList);
              Navigator.pop(context);
              if (success) {
                Get.snackbar('Success', 'Experience entry deleted', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openExperienceForm(BuildContext context, Experience? exp) {
    final isEdit = exp != null;
    final companyCtrl = TextEditingController(text: exp?.company ?? '');
    final roleCtrl = TextEditingController(text: exp?.role ?? '');
    final durCtrl = TextEditingController(text: exp?.duration ?? '');
    final achCtrl = TextEditingController(text: exp?.achievements.join('\n') ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Experience" : "Add Experience"),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: companyCtrl, decoration: const InputDecoration(labelText: "Company")),
                const SizedBox(height: 12),
                TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: "Role")),
                const SizedBox(height: 12),
                TextField(controller: durCtrl, decoration: const InputDecoration(labelText: "Duration")),
                const SizedBox(height: 12),
                TextField(
                  controller: achCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Achievements (one per line)",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<Experience> newList = List.from(controller.experience);

              final newExp = Experience(
                id: isEdit ? exp.id : 'exp-${DateTime.now().millisecondsSinceEpoch}',
                company: companyCtrl.text.trim(),
                role: roleCtrl.text.trim(),
                duration: durCtrl.text.trim(),
                achievements: achCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
              );

              if (isEdit) {
                final idx = newList.indexWhere((e) => e.id == exp.id);
                if (idx != -1) newList[idx] = newExp;
              } else {
                newList.add(newExp);
              }

              final success = await admin.updateExperience(newList);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Experience saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

// =======================
// 7. SKILLS TAB
// =======================
class _SkillsTab extends StatelessWidget {
  final bool isDark;
  const _SkillsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final skillsList = controller.skills;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Skills & Expertise",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _openSkillForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Skill Category"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: skillsList.length,
                itemBuilder: (context, index) {
                  final skill = skillsList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(skill.category, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text(skill.items.join(', ')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openSkillForm(context, skill),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Skill Category"),
        content: const Text("Are you sure you want to delete this skill category?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<SkillCategory> newList = List.from(controller.skills);
              newList.removeAt(index);
              final success = await admin.updateSkills(newList);
              Navigator.pop(context);
              if (success) {
                Get.snackbar('Success', 'Skill category deleted', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openSkillForm(BuildContext context, SkillCategory? cat) {
    final isEdit = cat != null;
    final catCtrl = TextEditingController(text: cat?.category ?? '');
    final itemsCtrl = TextEditingController(text: cat?.items.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Skill Category" : "Add Skill Category"),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Category Name (e.g. Mobile Development)")),
              const SizedBox(height: 12),
              TextField(
                controller: itemsCtrl,
                decoration: const InputDecoration(
                  labelText: "Skills (comma separated, e.g. Flutter, Dart, Android)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<SkillCategory> newList = List.from(controller.skills);

              final newCat = SkillCategory(
                category: catCtrl.text.trim(),
                items: itemsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
              );

              if (isEdit) {
                final idx = newList.indexWhere((c) => c.category == cat.category);
                if (idx != -1) newList[idx] = newCat;
              } else {
                newList.add(newCat);
              }

              final success = await admin.updateSkills(newList);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Skills saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

// =======================
// 8. AI WORKFLOW TAB
// =======================
class _AiWorkflowTab extends StatelessWidget {
  final bool isDark;
  const _AiWorkflowTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final aiList = controller.aiWorkflow;

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage AI Development Workflow",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _openAiForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Workflow Point"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: aiList.length,
                itemBuilder: (context, index) {
                  final point = aiList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.5) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(point.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text(point.description),
                      leading: Chip(
                        label: Text(point.icon),
                        backgroundColor: PortfolioTheme.primary.withOpacity(0.1),
                        labelStyle: const TextStyle(color: PortfolioTheme.primary, fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openAiForm(context, point),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete AI Workflow Point"),
        content: const Text("Are you sure you want to delete this workflow point?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<AiWorkflowPoint> newList = List.from(controller.aiWorkflow);
              newList.removeAt(index);
              final success = await admin.updateAiWorkflow(newList);
              Navigator.pop(context);
              if (success) {
                Get.snackbar('Success', 'Workflow point deleted', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openAiForm(BuildContext context, AiWorkflowPoint? point) {
    final isEdit = point != null;
    final titleCtrl = TextEditingController(text: point?.title ?? '');
    final descCtrl = TextEditingController(text: point?.description ?? '');
    String selectedIcon = point?.icon ?? 'code';

    final List<String> iconOptions = [
      'code',
      'psychology',
      'bolt',
      'analytics',
      'auto_awesome',
      'bug_report'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit AI Workflow Point" : "Add AI Workflow Point"),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
                const SizedBox(height: 12),
                TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedIcon,
                  decoration: const InputDecoration(labelText: "Icon Style"),
                  items: iconOptions.map((String opt) {
                    return DropdownMenuItem<String>(
                      value: opt,
                      child: Text(opt),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedIcon = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final controller = Get.find<PortfolioController>();
              final admin = Get.find<AdminController>();
              final List<AiWorkflowPoint> newList = List.from(controller.aiWorkflow);

              final newPoint = AiWorkflowPoint(
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                icon: selectedIcon,
              );

              if (isEdit) {
                final idx = newList.indexWhere((p) => p.title == point.title);
                if (idx != -1) newList[idx] = newPoint;
              } else {
                newList.add(newPoint);
              }

              final success = await admin.updateAiWorkflow(newList);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'AI Workflow saved', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
