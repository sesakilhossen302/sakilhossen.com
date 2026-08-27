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
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Obx(() {
      final messageCount = adminController.inboxMessages.length;
      final projectCount = portfolioController.projects.length;
      final reviewCount = portfolioController.references.length;

      final cards = [
        _StatCard(
          title: "Inbox Messages",
          value: "$messageCount",
          subtitle: messageCount > 0 ? "$messageCount Received" : "All Processed",
          icon: Icons.mail_outline_rounded,
          color: const Color(0xFF06B6D4),
          isDark: isDark,
          isDesktop: isDesktop,
          onTap: () => onTabSelected(0),
        ),
        _StatCard(
          title: "Total Projects",
          value: "$projectCount",
          subtitle: "Live in Portfolio",
          icon: Icons.folder_copy_outlined,
          color: const Color(0xFF3B82F6),
          isDark: isDark,
          isDesktop: isDesktop,
          onTap: () => onTabSelected(6),
        ),
        _StatCard(
          title: "Client Reviews",
          value: "$reviewCount",
          subtitle: "Testimonials",
          icon: Icons.star_outline_rounded,
          color: const Color(0xFFF59E0B),
          isDark: isDark,
          isDesktop: isDesktop,
          onTap: () => onTabSelected(7),
        ),
        _StatCard(
          title: "Live Status",
          value: "Online",
          subtitle: "Backend Connected",
          icon: Icons.cloud_done_outlined,
          color: const Color(0xFF10B981),
          isDark: isDark,
          isDesktop: isDesktop,
          onTap: () {},
        ),
      ];

      if (!isDesktop) {
        // Mobile horizontal scroll row (Compact 75px height)
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 75,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => cards[index],
          ),
        );
      }

      // Desktop 4-column row
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c))).toList(),
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
  final bool isDesktop;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      // Compact Mobile Card
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 170,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? PortfolioTheme.surfaceDark.withOpacity(0.6) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Text(
                        value,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Full Desktop Card
    return Material(
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : PortfolioTheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 10,
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
    );
  }
}
