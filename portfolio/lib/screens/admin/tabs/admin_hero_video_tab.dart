import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';
import '../../../widgets/image_picker_helper.dart';

class AdminHeroVideoTab extends StatefulWidget {
  final bool isDark;

  const AdminHeroVideoTab({super.key, required this.isDark});

  @override
  State<AdminHeroVideoTab> createState() => _AdminHeroVideoTabState();
}

class _AdminHeroVideoTabState extends State<AdminHeroVideoTab> {
  final List<TextEditingController> _heroVideoCtrls = [];

  @override
  void initState() {
    super.initState();
    final profile = Get.find<PortfolioController>().profile.value;
    _initVideoControllers(profile?.heroVideoUrl ?? '');
  }

  void _initVideoControllers(String rawUrl) {
    for (var c in _heroVideoCtrls) {
      c.dispose();
    }
    _heroVideoCtrls.clear();

    final links = rawUrl
        .split(RegExp(r'[\n,;]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .where((s) => s.startsWith('http://') || s.startsWith('https://') || s.startsWith('/uploads/'))
        .where((s) => !s.contains(';base64,') && s.length < 2000)
        .toList();

    if (links.isEmpty) {
      _heroVideoCtrls.add(TextEditingController(text: ''));
    } else {
      for (var link in links) {
        _heroVideoCtrls.add(TextEditingController(text: link));
      }
    }
  }

  @override
  void dispose() {
    for (var c in _heroVideoCtrls) {
      c.dispose();
    }
    _heroVideoCtrls.clear();
    super.dispose();
  }

  void _addNewVideoField() {
    setState(() {
      _heroVideoCtrls.add(TextEditingController(text: ''));
    });
  }

  void _confirmDeleteVideoField(int index) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
            const SizedBox(width: 10),
            Text(
              "Delete Video Link?",
              style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to remove Video #${index + 1} from your background playlist?",
          style: GoogleFonts.inter(color: const Color(0xFFCBD5E1), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.outfit(color: Colors.grey[400])),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever_rounded, size: 18),
            label: const Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Get.back();
              setState(() {
                _heroVideoCtrls[index].dispose();
                _heroVideoCtrls.removeAt(index);
                if (_heroVideoCtrls.isEmpty) {
                  _heroVideoCtrls.add(TextEditingController(text: ''));
                }
              });
              _saveHeroPlaylist();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveHeroPlaylist() async {
    final currentJoinedVideoUrls = _heroVideoCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .join('\n');

    final success = await Get.find<AdminController>().updateProfileMap({
      'heroVideoUrl': currentJoinedVideoUrls,
    });

    if (success) {
      Get.snackbar('Success', 'Background Hero Video playlist saved successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to save video playlist', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
                    color: const Color(0xFF8B5CF6).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.video_library_rounded, color: Color(0xFF8B5CF6), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hero Background Video Playlist",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        "Manage your Hero section background video playlist. Paste Google Drive share links or direct MP4 URLs.",
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

            // Video Fields List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _heroVideoCtrls.length,
              itemBuilder: (context, idx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.white10 : Colors.black.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "#${idx + 1}",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF8B5CF6),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _heroVideoCtrls[idx],
                          decoration: InputDecoration(
                            labelText: "Hero Video URL #${idx + 1}",
                            hintText: "Paste Google Drive share link or direct MP4 URL",
                            prefixIcon: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF8B5CF6)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.upload_file_rounded, color: PortfolioTheme.accent),
                        tooltip: "Upload video file",
                        onPressed: () async {
                          final videoPath = await pickVideoAsBase64();
                          if (videoPath != null) {
                            setState(() {
                              _heroVideoCtrls[idx].text = videoPath;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        tooltip: "Delete video",
                        onPressed: () => _confirmDeleteVideoField(idx),
                      ),
                    ],
                  ),
                );
              },
            ),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text("Add Another Video to Playlist"),
              onPressed: _addNewVideoField,
            ),
            const SizedBox(height: 36),

            // Dedicated Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  "Save Video Playlist",
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveHeroPlaylist,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
