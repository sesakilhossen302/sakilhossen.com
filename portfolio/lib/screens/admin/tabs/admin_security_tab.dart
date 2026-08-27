import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminSecurityTab extends StatefulWidget {
  final bool isDark;

  const AdminSecurityTab({super.key, required this.isDark});

  @override
  State<AdminSecurityTab> createState() => _AdminSecurityTabState();
}

class _AdminSecurityTabState extends State<AdminSecurityTab> {
  late TextEditingController _newPasswordCtrl;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _newPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final newPass = _newPasswordCtrl.text.trim();
    if (newPass.isEmpty) {
      Get.snackbar('Error', 'Please enter a new password', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final success = await Get.find<AdminController>().changePassword(newPass);
    if (success) {
      _newPasswordCtrl.clear();
      Get.snackbar('Success', 'Admin password updated successfully in MongoDB Atlas!', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to update password. Check backend connection.', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
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
                    color: const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin Security & Password Settings",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        "Update your admin authentication password stored securely with bcrypt hashing in MongoDB Atlas.",
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

            TextFormField(
              controller: _newPasswordCtrl,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "New Admin Password",
                hintText: "Enter strong new password (e.g. Sakil@302)",
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
            const SizedBox(height: 36),

            // Dedicated Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.security_rounded),
                label: Text(
                  "Update Admin Password",
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _updatePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
