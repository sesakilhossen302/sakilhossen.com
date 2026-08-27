import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminContactLinksTab extends StatefulWidget {
  final bool isDark;

  const AdminContactLinksTab({super.key, required this.isDark});

  @override
  State<AdminContactLinksTab> createState() => _AdminContactLinksTabState();
}

class _AdminContactLinksTabState extends State<AdminContactLinksTab> {
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _cvUrlCtrl;
  late TextEditingController _githubUrlCtrl;
  late TextEditingController _linkedinUrlCtrl;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<PortfolioController>().profile.value;
    _phoneCtrl = TextEditingController(text: profile?.phone ?? '');
    _emailCtrl = TextEditingController(text: profile?.email ?? '');
    _locationCtrl = TextEditingController(text: profile?.location ?? '');
    _cvUrlCtrl = TextEditingController(text: profile?.cvUrl ?? '');
    _githubUrlCtrl = TextEditingController(text: profile?.githubUrl ?? '');
    _linkedinUrlCtrl = TextEditingController(text: profile?.linkedinUrl ?? '');
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _cvUrlCtrl.dispose();
    _githubUrlCtrl.dispose();
    _linkedinUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveContactLinks() async {
    final success = await Get.find<AdminController>().updateProfileMap({
      'phone': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'cvUrl': _cvUrlCtrl.text.trim(),
      'githubUrl': _githubUrlCtrl.text.trim(),
      'linkedinUrl': _linkedinUrlCtrl.text.trim(),
    });

    if (success) {
      Get.snackbar('Success', 'Contact details & Social links updated!', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to update contact links', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
            // Page Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.contact_phone_rounded, color: Color(0xFF3B82F6), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Info & Social Links",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        "Manage your phone number, email address, location, CV download link, GitHub & LinkedIn URLs.",
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

            _buildResponsiveRow(
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  hintText: "e.g. +8801700000000",
                ),
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email),
                  hintText: "e.g. sesakilhossen302@gmail.com",
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildResponsiveRow(
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                  hintText: "e.g. Dhaka, Bangladesh",
                ),
              ),
              TextFormField(
                controller: _cvUrlCtrl,
                decoration: const InputDecoration(
                  labelText: "CV Download URL / Link",
                  prefixIcon: Icon(Icons.file_download_rounded),
                  hintText: "e.g. https://sakilhossen.com",
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildResponsiveRow(
              TextFormField(
                controller: _githubUrlCtrl,
                decoration: const InputDecoration(
                  labelText: "GitHub URL",
                  prefixIcon: Icon(Icons.link),
                  hintText: "e.g. https://github.com/sesakilhossen302",
                ),
              ),
              TextFormField(
                controller: _linkedinUrlCtrl,
                decoration: const InputDecoration(
                  labelText: "LinkedIn URL",
                  prefixIcon: Icon(Icons.link),
                  hintText: "e.g. https://linkedin.com/in/sesakilhossen302",
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Dedicated Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  "Save Contact Links",
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveContactLinks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
