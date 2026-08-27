import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../theme/portfolio_theme.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final bool isDark;
  final bool isDrawer;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDark,
    this.isDrawer = false,
  });

  static const List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.mail_outline_rounded, 'label': 'Inbox Messages', 'badgeKey': 'inbox'},
    {'icon': Icons.person_outline_rounded, 'label': 'Edit Profile'},
    {'icon': Icons.folder_copy_outlined, 'label': 'Manage Projects'},
    {'icon': Icons.star_outline_rounded, 'label': 'Client Reviews'},
    {'icon': Icons.school_outlined, 'label': 'Education'},
    {'icon': Icons.work_outline_rounded, 'label': 'Work Experience'},
    {'icon': Icons.psychology_outlined, 'label': 'Skills Category'},
    {'icon': Icons.auto_awesome_outlined, 'label': 'AI Workflow'},
  ];

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final portfolioController = Get.find<PortfolioController>();

    final bgColor = isDark ? PortfolioTheme.surfaceDark : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.black.withOpacity(0.08);

    return Container(
      width: isDrawer ? 280 : 260,
      height: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        children: [
          // Admin Brand Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: PortfolioTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PortfolioTheme.primary, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      "S",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: PortfolioTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sakil Hossen",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Admin Portal",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Tabs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedIndex == index;

                return Obx(() {
                  int badgeCount = 0;
                  if (item['badgeKey'] == 'inbox') {
                    badgeCount = adminController.inboxMessages.length;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          onTabSelected(index);
                          if (isDrawer) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PortfolioTheme.primary.withOpacity(isDark ? 0.2 : 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? PortfolioTheme.primary : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 20,
                                color: isSelected
                                    ? PortfolioTheme.primary
                                    : (isDark ? Colors.white70 : Colors.black54),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['label'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? PortfolioTheme.primary
                                        : (isDark ? Colors.white : PortfolioTheme.secondary),
                                  ),
                                ),
                              ),
                              if (badgeCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "$badgeCount",
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          // Bottom Sidebar Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor, width: 1)),
            ),
            child: Column(
              children: [
                // Live Website Link
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      const url = 'https://sakilhossen.com';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF06B6D4)),
                          const SizedBox(width: 10),
                          Text(
                            "View Live Website",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : PortfolioTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Theme Toggle & Logout Row
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              size: 18,
                              color: isDark ? Colors.yellowAccent : PortfolioTheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDark ? "Light" : "Dark",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onPressed: portfolioController.toggleTheme,
                      ),
                    ),
                    Container(width: 1, height: 20, color: borderColor),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.redAccent),
                        label: Text(
                          "Logout",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () {
                          adminController.logout();
                          Get.offNamed('/');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
