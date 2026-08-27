import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';

class AdminEducationTab extends StatelessWidget {
  final bool isDark;

  const AdminEducationTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final educationList = controller.education;

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Education & Qualifications",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openEducationForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Education"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: educationList.length,
                itemBuilder: (context, index) {
                  final edu = educationList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
