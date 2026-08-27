import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminStatsHeader extends StatelessWidget {
  final bool isDark;
  final Function(int) onTabSelected;

  const AdminStatsHeader({
    super.key,
    required this.isDark,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final portfolioController = Get.find<PortfolioController>();

    return Obx(() {
      final messageCount = adminController.inboxMessages.length;
      final projectCount = portfolioController.projects.length;
      final reviewCount = portfolioController.references.length;

      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(
              title: "Inbox Messages",
              value: "$messageCount",
              subtitle: messageCount > 0 ? "$messageCount Received" : "All Processed",
              icon: Icons.mail_outline_rounded,
              color: const Color(0xFF06B6D4),
              isDark: isDark,
              onTap: () => onTabSelected(0),
            ),
            _StatCard(
              title: "Total Projects",
              value: "$projectCount",
              subtitle: "Live in Portfolio",
              icon: Icons.folder_copy_outlined,
              color: const Color(0xFF3B82F6),
              isDark: isDark,
              onTap: () => onTabSelected(6),
            ),
            _StatCard(
              title: "Client Reviews",
              value: "$reviewCount",
              subtitle: "Testimonials",
              icon: Icons.star_outline_rounded,
              color: const Color(0xFFF59E0B),
              isDark: isDark,
              onTap: () => onTabSelected(7),
            ),
            _StatCard(
              title: "Live Status",
              value: "Online",
              subtitle: "Backend Connected",
              icon: Icons.cloud_done_outlined,
              color: const Color(0xFF10B981),
              isDark: isDark,
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width > 900
        ? (MediaQuery.of(context).size.width - 320 - 48 - 48) / 4
        : (MediaQuery.of(context).size.width > 600
            ? (MediaQuery.of(context).size.width - 64) / 2
            : double.infinity);

    return SizedBox(
      width: cardWidth < 180 ? double.infinity : cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
