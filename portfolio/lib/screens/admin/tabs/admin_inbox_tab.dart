import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminInboxTab extends StatelessWidget {
  final bool isDark;

  const AdminInboxTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();

    return Obx(() {
      final messages = adminController.inboxMessages;
      final loading = adminController.isLoadingInbox.value;

      if (loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 56,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              const SizedBox(height: 16),
              Text(
                "Your inbox is currently empty",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "New messages sent from the Contact form will appear here live.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Refresh Inbox"),
                onPressed: adminController.fetchInbox,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: adminController.fetchInbox,
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: PortfolioTheme.primary.withOpacity(0.15),
                  child: const Icon(Icons.person_rounded, color: PortfolioTheme.primary),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      msg.name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : PortfolioTheme.secondary,
                      ),
                    ),
                    Text(
                      msg.timestamp.length >= 10 ? msg.timestamp.substring(0, 10) : msg.timestamp,
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      msg.email,
                      style: GoogleFonts.inter(
                        color: PortfolioTheme.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      msg.message,
                      style: GoogleFonts.inter(
                        height: 1.5,
                        color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () => _confirmDeleteMessage(context, msg.id),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _confirmDeleteMessage(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Message"),
        content: const Text("Are you sure you want to delete this contact message permanently?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.find<AdminController>().deleteInboxMessage(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
