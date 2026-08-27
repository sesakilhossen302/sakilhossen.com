import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../widgets/portfolio_image.dart';
import '../../../widgets/image_picker_helper.dart';

class AdminProfileIdentityTab extends StatefulWidget {
  final bool isDark;

  const AdminProfileIdentityTab({super.key, required this.isDark});

  @override
  State<AdminProfileIdentityTab> createState() => _AdminProfileIdentityTabState();
}

class _AdminProfileIdentityTabState extends State<AdminProfileIdentityTab> {
  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _taglineCtrl;
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    final profile = Get.find<PortfolioController>().profile.value;
    _nameCtrl = TextEditingController(text: profile?.name ?? '');
    _titleCtrl = TextEditingController(text: profile?.title ?? '');
    _taglineCtrl = TextEditingController(text: profile?.tagline ?? '');
    _profileImage = profile?.profileImage ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveIdentity() async {
    final name = _nameCtrl.text.trim();
    final title = _titleCtrl.text.trim();
    final tagline = _taglineCtrl.text.trim();

    if (name.isEmpty || title.isEmpty) {
      Get.snackbar('Error', 'Name and Title are required', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final success = await Get.find<AdminController>().updateProfileMap({
      'name': name,
      'title': title,
      'tagline': tagline,
      'profileImage': _profileImage,
    });

    if (success) {
      Get.snackbar('Success', 'Profile Identity updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to update identity', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
    final bgColor = widget.isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white;
    final borderColor = widget.isDark ? Colors.white12 : Colors.black.withOpacity(0.08);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.person_pin_rounded, color: Color(0xFF06B6D4), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile & Identity Management",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        "Manage your primary avatar, full name, profession title & hero status tagline.",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: widget.isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Profile Photo Upload Section
            Text(
              "Profile Photo Avatar",
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: PortfolioTheme.primary.withOpacity(0.15),
                  child: ClipOval(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: PortfolioImage(imageSource: _profileImage),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  icon: const Icon(Icons.image_search_rounded),
                  label: const Text("Upload New Photo"),
                  onPressed: () async {
                    final base64Image = await pickImageAsBase64();
                    if (base64Image != null) {
                      setState(() {
                        _profileImage = base64Image;
                      });
                    }
                  },
                ),
                if (_profileImage.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    label: const Text("Remove", style: TextStyle(color: Colors.redAccent)),
                    onPressed: () {
                      setState(() {
                        _profileImage = '';
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildResponsiveRow(
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  hintText: "e.g. S.E. Sakil Hossen",
                ),
              ),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Profession Title",
                  prefixIcon: Icon(Icons.badge),
                  hintText: "e.g. Flutter Mobile Application Developer",
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _taglineCtrl,
              decoration: const InputDecoration(
                labelText: "Hero Status Tagline",
                prefixIcon: Icon(Icons.announcement),
                hintText: "e.g. Available for Hire & Projects",
              ),
            ),
            const SizedBox(height: 36),

            // Dedicated Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  "Save Identity Details",
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveIdentity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
