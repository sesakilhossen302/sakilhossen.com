import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/project_model.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../widgets/portfolio_image.dart';
import '../../../widgets/image_picker_helper.dart';

class AdminProjectsTab extends StatelessWidget {
  final bool isDark;

  const AdminProjectsTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final projects = controller.projects;

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Project Gallery",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openProjectForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Project"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final proj = projects[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 54,
                          height: 54,
                          child: PortfolioImage(imageSource: proj.image),
                        ),
                      ),
                      title: Text(
                        proj.title,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        proj.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 13),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openProjectForm(context, proj),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteProject(context, proj.id),
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

  void _confirmDeleteProject(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Project"),
        content: const Text("Are you sure you want to delete this project?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteProject(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openProjectForm(BuildContext context, Project? project) {
    final isEdit = project != null;

    final titleCtrl = TextEditingController(text: project?.title ?? '');
    final descCtrl = TextEditingController(text: project?.description ?? '');
    final imgCtrl = TextEditingController(text: project?.image ?? '');
    final playCtrl = TextEditingController(text: project?.playStoreUrl ?? '');
    final appCtrl = TextEditingController(text: project?.appStoreUrl ?? '');
    final gitCtrl = TextEditingController(text: project?.githubUrl ?? '');
    final tagsCtrl = TextEditingController(text: project?.tags.join(', ') ?? '');
    final featuresCtrl = TextEditingController(text: project?.features.join('\n') ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEdit ? "Edit Project" : "Add Project"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Project Title")),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "About / Description")),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imgCtrl,
                          decoration: const InputDecoration(
                            labelText: "Image (Asset path or Base64)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded),
                        tooltip: "Upload image file",
                        onPressed: () async {
                          final base64Image = await pickImageAsBase64();
                          if (base64Image != null) {
                            setDialogState(() {
                              imgCtrl.text = base64Image;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (imgCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: PortfolioImage(imageSource: imgCtrl.text),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(controller: playCtrl, decoration: const InputDecoration(labelText: "Google Play Store Link")),
                  const SizedBox(height: 12),
                  TextField(controller: appCtrl, decoration: const InputDecoration(labelText: "Apple App Store Link")),
                  const SizedBox(height: 12),
                  TextField(controller: gitCtrl, decoration: const InputDecoration(labelText: "GitHub Link")),
                  const SizedBox(height: 12),
                  TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: "Tags (comma-separated, e.g. Flutter, Dart)")),
                  const SizedBox(height: 12),
                  TextField(controller: featuresCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Key Features (one per line)")),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final newProj = Project(
                  id: isEdit ? project.id : 'proj-${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  image: imgCtrl.text.trim(),
                  playStoreUrl: playCtrl.text.trim(),
                  appStoreUrl: appCtrl.text.trim(),
                  githubUrl: gitCtrl.text.trim(),
                  tags: tagsCtrl.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
                  features: featuresCtrl.text.split('\n').map((f) => f.trim()).where((f) => f.isNotEmpty).toList(),
                );

                final admin = Get.find<AdminController>();
                bool success = false;
                if (isEdit) {
                  success = await admin.updateProject(newProj);
                } else {
                  success = await admin.addProject(newProj);
                }

                if (success) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Project saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
