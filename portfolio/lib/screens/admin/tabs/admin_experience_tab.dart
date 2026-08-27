import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';

class AdminExperienceTab extends StatelessWidget {
  final bool isDark;

  const AdminExperienceTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final experienceList = controller.experience;

      return Padding(
        padding: const EdgeInsets.all(24.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openExperienceForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Experience"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: experienceList.length,
                itemBuilder: (context, index) {
                  final exp = experienceList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
