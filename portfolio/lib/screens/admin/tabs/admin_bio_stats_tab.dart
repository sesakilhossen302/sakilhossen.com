import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminBioStatsTab extends StatefulWidget {
  final bool isDark;

  const AdminBioStatsTab({super.key, required this.isDark});

  @override
  State<AdminBioStatsTab> createState() => _AdminBioStatsTabState();
}

class _AdminBioStatsTabState extends State<AdminBioStatsTab> {
  late TextEditingController _bioCtrl;
  late TextEditingController _expYearsCtrl;
  late TextEditingController _completedProjCtrl;
  late TextEditingController _clientsCtrl;
  late TextEditingController _philosophyCtrl;
  late TextEditingController _goalsCtrl;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<PortfolioController>().profile.value;
    _bioCtrl = TextEditingController(text: profile?.bio ?? '');
    _expYearsCtrl = TextEditingController(text: profile?.experienceYears ?? '');
    _completedProjCtrl = TextEditingController(text: profile?.completedProjects ?? '');
    _clientsCtrl = TextEditingController(text: profile?.happyClients ?? '');
    _philosophyCtrl = TextEditingController(text: profile?.developmentPhilosophy ?? '');
    _goalsCtrl = TextEditingController(text: profile?.careerGoals ?? '');
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _expYearsCtrl.dispose();
    _completedProjCtrl.dispose();
    _clientsCtrl.dispose();
    _philosophyCtrl.dispose();
    _goalsCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveBioAndStats() async {
    final success = await Get.find<AdminController>().updateProfileMap({
      'bio': _bioCtrl.text.trim(),
      'experienceYears': _expYearsCtrl.text.trim(),
      'completedProjects': _completedProjCtrl.text.trim(),
      'happyClients': _clientsCtrl.text.trim(),
      'developmentPhilosophy': _philosophyCtrl.text.trim(),
      'careerGoals': _goalsCtrl.text.trim(),
    });

    if (success) {
      Get.snackbar('Success', 'Bio, Portfolio Stats & Philosophy saved!', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to update stats & bio', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Color(0xFF10B981), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bio, Key Stats & Career Goals",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        "Manage your professional bio summary, key counters (years, projects, clients) & development philosophy.",
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
              controller: _bioCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Professional Biography",
                prefixIcon: Icon(Icons.description),
                hintText: "Enter detailed overview of your technical background, skills, and client track record...",
              ),
            ),
            const SizedBox(height: 20),

            _buildResponsiveRow(
              TextFormField(
                controller: _expYearsCtrl,
                decoration: const InputDecoration(
                  labelText: "Experience Years (e.g. 2+ Years)",
                  prefixIcon: Icon(Icons.timeline),
                ),
              ),
              TextFormField(
                controller: _completedProjCtrl,
                decoration: const InputDecoration(
                  labelText: "Completed Projects Count (e.g. 20+)",
                  prefixIcon: Icon(Icons.task_alt),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _clientsCtrl,
              decoration: const InputDecoration(
                labelText: "Happy Clients / Stakeholders (e.g. 25+)",
                prefixIcon: Icon(Icons.sentiment_very_satisfied),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _philosophyCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Development Philosophy",
                prefixIcon: Icon(Icons.lightbulb),
                hintText: "e.g. Clean code architecture with extreme performance & UI delight.",
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _goalsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Career Goals",
                prefixIcon: Icon(Icons.flag),
                hintText: "e.g. Building next-gen mobile platforms with Flutter & AI.",
              ),
            ),
            const SizedBox(height: 36),

            // Dedicated Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  "Save Bio & Stats",
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveBioAndStats,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
