import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';

class AdminAiWorkflowTab extends StatelessWidget {
  final bool isDark;

  const AdminAiWorkflowTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final aiList = controller.aiWorkflow;

      return Padding(
        padding: const EdgeInsets.all(24.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openAiForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Workflow Point"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: aiList.length,
                itemBuilder: (context, index) {
                  final point = aiList[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
