import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';

class AdminSkillsTab extends StatelessWidget {
  final bool isDark;

  const AdminSkillsTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final skillsList = controller.skills;

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Skills & Technical Stack",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openSkillForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Skill Category"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: skillsList.length,
                itemBuilder: (context, index) {
                  final skill = skillsList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
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

  void _openSkillForm(BuildContext context, SkillCategory? skill) {
    final isEdit = skill != null;
    final catCtrl = TextEditingController(text: skill?.category ?? '');
    final itemsCtrl = TextEditingController(text: skill?.items.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isEdit ? "Edit Skill Category" : "Add Skill Category"),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Category Title (e.g. Mobile Development)")),
                const SizedBox(height: 12),
                TextField(
                  controller: itemsCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Skill Items (comma-separated, e.g. Flutter, Dart, GetX)",
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
              final List<SkillCategory> newList = List.from(controller.skills);

              final newSkill = SkillCategory(
                category: catCtrl.text.trim(),
                items: itemsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
              );

              if (isEdit) {
                final idx = newList.indexWhere((s) => s.category == skill.category);
                if (idx != -1) newList[idx] = newSkill;
              } else {
                newList.add(newSkill);
              }

              final success = await admin.updateSkills(newList);
              if (success) {
                Navigator.pop(context);
                Get.snackbar('Success', 'Skill category saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
