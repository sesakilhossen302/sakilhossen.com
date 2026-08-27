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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'code':
        return Icons.code_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'analytics':
        return Icons.analytics_rounded;
      case 'bug_report':
        return Icons.bug_report_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final aiList = controller.aiWorkflow;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Development Workflow Points",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : PortfolioTheme.secondary,
                      ),
                    ),
                    Text(
                      "Manage AI process points displayed in your portfolio AI Workflow section.",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _openAiForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Workflow Point"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: aiList.length,
              itemBuilder: (context, index) {
                final point = aiList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: PortfolioTheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_getIconData(point.icon), size: 16, color: PortfolioTheme.primary),
                                const SizedBox(width: 6),
                                Text(
                                  point.icon,
                                  style: GoogleFonts.inter(
                                    color: PortfolioTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
                            onPressed: () => _openAiForm(context, point),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () => _confirmDelete(context, index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        point.title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        point.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.45,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Delete AI Workflow Point?",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete this workflow point from MongoDB?",
          style: GoogleFonts.inter(color: const Color(0xFFCBD5E1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.outfit(color: Colors.grey[400])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
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
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isEdit ? "Edit AI Workflow Point" : "Add AI Workflow Point",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Title", prefixIcon: Icon(Icons.title)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description", prefixIcon: Icon(Icons.description)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedIcon,
                  decoration: const InputDecoration(labelText: "Icon Category", prefixIcon: Icon(Icons.category)),
                  items: iconOptions.map((icon) {
                    return DropdownMenuItem(
                      value: icon,
                      child: Row(
                        children: [
                          Icon(_getIconData(icon), size: 18),
                          const SizedBox(width: 10),
                          Text(icon),
                        ],
                      ),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: PortfolioTheme.primary, foregroundColor: Colors.white),
              onPressed: () async {
                final title = titleCtrl.text.trim();
                final desc = descCtrl.text.trim();

                if (title.isEmpty || desc.isEmpty) {
                  Get.snackbar('Error', 'Please fill all fields', backgroundColor: Colors.redAccent, colorText: Colors.white);
                  return;
                }

                final controller = Get.find<PortfolioController>();
                final admin = Get.find<AdminController>();
                final List<AiWorkflowPoint> newList = List.from(controller.aiWorkflow);

                if (isEdit) {
                  final idx = newList.indexWhere((p) => p.title == point.title);
                  if (idx != -1) {
                    newList[idx] = AiWorkflowPoint(icon: selectedIcon, title: title, description: desc);
                  }
                } else {
                  newList.add(AiWorkflowPoint(icon: selectedIcon, title: title, description: desc));
                }

                final success = await admin.updateAiWorkflow(newList);
                Navigator.pop(context);

                if (success) {
                  Get.snackbar('Success', 'AI Workflow updated', backgroundColor: Colors.green, colorText: Colors.white);
                }
              },
              child: Text(isEdit ? "Update" : "Add"),
            ),
          ],
        ),
      ),
    );
  }
}
