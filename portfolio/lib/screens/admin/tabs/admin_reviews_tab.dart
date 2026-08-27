import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../widgets/portfolio_image.dart';
import '../../../widgets/image_picker_helper.dart';

class AdminReviewsTab extends StatelessWidget {
  final bool isDark;

  const AdminReviewsTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final reviews = controller.references;

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Client Testimonials",
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PortfolioTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => _openReviewForm(context, null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add New Review"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final ref = reviews[index];
                  return Card(
                    color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        child: ClipOval(
                          child: PortfolioImage(imageSource: ref.clientImage),
                        ),
                      ),
                      title: Text(ref.clientName, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      subtitle: Text("${ref.clientCompany} - Rating: ${ref.clientRating}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                            onPressed: () => _openReviewForm(context, ref),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteReview(context, ref.id),
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

  void _confirmDeleteReview(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Review"),
        content: const Text("Are you sure you want to delete this recommendation permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteReference(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openReviewForm(BuildContext context, ClientReference? ref) {
    final isEdit = ref != null;

    final nameCtrl = TextEditingController(text: ref?.clientName ?? '');
    final compCtrl = TextEditingController(text: ref?.clientCompany ?? '');
    final commentCtrl = TextEditingController(text: ref?.clientComment ?? '');
    final ratingCtrl = TextEditingController(text: ref?.clientRating.toString() ?? '5.0');
    final imgCtrl = TextEditingController(text: ref?.clientImage ?? '');
    final screenshotCtrl = TextEditingController(text: ref?.reviewImage ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEdit ? "Edit Client Review" : "Add Client Review"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Client Name")),
                  const SizedBox(height: 12),
                  TextField(controller: compCtrl, decoration: const InputDecoration(labelText: "Company / Role")),
                  const SizedBox(height: 12),
                  TextField(controller: commentCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Review Comment")),
                  const SizedBox(height: 12),
                  TextField(controller: ratingCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Rating (e.g. 5.0)")),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imgCtrl,
                          decoration: const InputDecoration(
                            labelText: "Client Photo (URL or Base64)",
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
                    CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: PortfolioImage(imageSource: imgCtrl.text),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: screenshotCtrl,
                          decoration: const InputDecoration(
                            labelText: "Fiverr Review Screenshot (URL or Base64)",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded),
                        tooltip: "Upload screenshot file",
                        onPressed: () async {
                          final base64Image = await pickImageAsBase64();
                          if (base64Image != null) {
                            setDialogState(() {
                              screenshotCtrl.text = base64Image;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (screenshotCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: PortfolioImage(
                          imageSource: screenshotCtrl.text,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                final newRef = ClientReference(
                  id: isEdit ? ref.id : 'ref-${DateTime.now().millisecondsSinceEpoch}',
                  clientName: nameCtrl.text.trim(),
                  clientCompany: compCtrl.text.trim(),
                  clientComment: commentCtrl.text.trim(),
                  clientRating: double.tryParse(ratingCtrl.text) ?? 5.0,
                  clientImage: imgCtrl.text.trim(),
                  reviewImage: screenshotCtrl.text.trim(),
                );

                final admin = Get.find<AdminController>();
                bool success = false;
                if (isEdit) {
                  success = await admin.updateReference(newRef);
                } else {
                  success = await admin.addReference(newRef);
                }

                if (success) {
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Recommendation saved successfully', backgroundColor: Colors.green, colorText: Colors.white);
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
