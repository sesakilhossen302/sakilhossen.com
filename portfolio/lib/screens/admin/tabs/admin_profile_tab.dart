import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../widgets/portfolio_image.dart';
import '../../../widgets/image_picker_helper.dart';

class AdminProfileTab extends StatefulWidget {
  final bool isDark;

  const AdminProfileTab({super.key, required this.isDark});

  @override
  State<AdminProfileTab> createState() => _AdminProfileTabState();
}

class _AdminProfileTabState extends State<AdminProfileTab> {
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
        .where((s) => s.startsWith('http://') || s.startsWith('https://') || s.startsWith('/uploads/'))
        .where((s) => !s.contains(';base64,') && s.length < 2000)
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

  Widget _buildResponsiveRow(Widget field1, Widget field2) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 650) {
          return Row(
            children: [
              Expanded(child: field1),
              const SizedBox(width: 16),
              Expanded(child: field2),
            ],
          );
        }
        return Column(
          children: [
            field1,
            const SizedBox(height: 16),
            field2,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Public Brand & Profile Information",
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

            _buildResponsiveRow(
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Profession Title", prefixIcon: Icon(Icons.badge)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 16),

            _buildResponsiveRow(
              TextFormField(
                controller: _taglineCtrl,
                decoration: const InputDecoration(labelText: "Hero Tagline", prefixIcon: Icon(Icons.announcement)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 16),

            _buildResponsiveRow(
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(labelText: "Location", prefixIcon: Icon(Icons.location_on)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 16),

            _buildResponsiveRow(
              TextFormField(
                controller: _githubUrlCtrl,
                decoration: const InputDecoration(labelText: "GitHub URL", prefixIcon: Icon(Icons.link)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _linkedinUrlCtrl,
                decoration: const InputDecoration(labelText: "LinkedIn URL", prefixIcon: Icon(Icons.link)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _bioCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Professional Biography", prefixIcon: Icon(Icons.description)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _cvUrlCtrl,
              decoration: const InputDecoration(labelText: "CV Download URL / PDF Link", prefixIcon: Icon(Icons.file_download_rounded)),
            ),
            const SizedBox(height: 32),

            Text(
              "Background Hero Video Playlist",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _heroVideoCtrls.length,
              itemBuilder: (context, idx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heroVideoCtrls[idx],
                          decoration: InputDecoration(
                            labelText: "Hero Video URL #${idx + 1}",
                            prefixIcon: const Icon(Icons.play_circle_fill_rounded, color: PortfolioTheme.primary),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded, color: PortfolioTheme.accent),
                        onPressed: () async {
                          final videoPath = await pickVideoAsBase64();
                          if (videoPath != null) {
                            setState(() {
                              _heroVideoCtrls[idx].text = videoPath;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: () => _confirmDeleteVideoField(idx),
                      ),
                    ],
                  ),
                );
              },
            ),

            TextButton.icon(
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text("Add Another Video to Playlist"),
              onPressed: _addNewVideoField,
            ),
            const SizedBox(height: 32),

            Text(
              "Key Statistics & Philosophy",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildResponsiveRow(
              TextFormField(
                controller: _expYearsCtrl,
                decoration: const InputDecoration(labelText: "Experience (Years)", prefixIcon: Icon(Icons.timeline)),
              ),
              TextFormField(
                controller: _completedProjCtrl,
                decoration: const InputDecoration(labelText: "Completed Projects Count", prefixIcon: Icon(Icons.task_alt)),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _clientsCtrl,
              decoration: const InputDecoration(labelText: "Happy Clients / Stakeholders", prefixIcon: Icon(Icons.sentiment_very_satisfied)),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _philosophyCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: "Development Philosophy", prefixIcon: Icon(Icons.psychology)),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _goalsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: "Career Goals", prefixIcon: Icon(Icons.flag)),
            ),
            const SizedBox(height: 32),

            Text(
              "Security & Access",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _newPasswordCtrl,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Change Admin Password",
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
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_rounded),
                label: const Text("Save All Profile Changes"),
                onPressed: _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
