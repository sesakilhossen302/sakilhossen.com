import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';
import 'responsive_widget.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final activeIndex = controller.activeSectionIndex.value;

      return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: (isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight).withOpacity(0.25),
              width: 1,
            ),
          ),
        ),
        child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveWidget.isDesktop(context) 
                    ? MediaQuery.of(context).size.width * 0.08 
                    : 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo/Name
                  GestureDetector(
                    onTap: () => controller.scrollToSection(0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          Text(
                            "Sakil Hossen",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(left: 4, top: 10),
                            decoration: const BoxDecoration(
                              color: PortfolioTheme.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Desktop Nav Links
                  if (isDesktop)
                    Row(
                      children: [
                        _NavLink(title: "Home", index: 0, isActive: activeIndex == 0),
                        _NavLink(title: "About", index: 1, isActive: activeIndex == 1),
                        _NavLink(title: "Skills", index: 2, isActive: activeIndex == 2),
                        _NavLink(title: "Experience", index: 3, isActive: activeIndex == 3),
                        _NavLink(title: "Projects", index: 4, isActive: activeIndex == 4),
                        _NavLink(title: "AI Work", index: 5, isActive: activeIndex == 5),
                        _NavLink(title: "Education", index: 6, isActive: activeIndex == 6),
                        _NavLink(title: "Reviews", index: 7, isActive: activeIndex == 7),
                        _NavLink(title: "Contact", index: 8, isActive: activeIndex == 8),
                      ],
                    ),

                  // Right Side Actions
                  Row(
                    children: [
                      // Theme Switcher
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: isDark ? Colors.yellowAccent : Colors.amberAccent,
                        ),
                        tooltip: 'Toggle Theme',
                        onPressed: controller.toggleTheme,
                      ),
                      const SizedBox(width: 8),

                      // Admin Login Redirect Shield Icon
                      IconButton(
                        icon: Icon(
                          Icons.admin_panel_settings_rounded,
                          color: PortfolioTheme.accent,
                        ),
                        tooltip: 'Admin Panel',
                        onPressed: () => Get.toNamed('/admin'),
                      ),

                      // Mobile Hamburger Menu Trigger
                      if (!isDesktop) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
      );
    });
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final int index;
  final bool isActive;

  const _NavLink({
    required this.title,
    required this.index,
    required this.isActive,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    final Color normalColor = const Color(0xFFCBD5E1);
    final Color activeColor = Colors.white;
    final Color hoverColor = PortfolioTheme.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => controller.scrollToSection(widget.index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: widget.isActive || _isHovered ? FontWeight.bold : FontWeight.w500,
                  color: widget.isActive 
                      ? activeColor 
                      : (_isHovered ? hoverColor : normalColor),
                ),
                child: Text(widget.title),
              ),
              const SizedBox(height: 4),
              // Indicator Line
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: widget.isActive ? 20 : (_isHovered ? 12 : 0),
                decoration: BoxDecoration(
                  gradient: PortfolioTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final activeIndex = controller.activeSectionIndex.value;
      
      return Drawer(
        backgroundColor: isDark ? PortfolioTheme.bgDark : PortfolioTheme.bgLight,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Navigation",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : PortfolioTheme.secondary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: isDark ? Colors.white : PortfolioTheme.secondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    _DrawerLink(title: "Home", index: 0, isActive: activeIndex == 0),
                    _DrawerLink(title: "About Me", index: 1, isActive: activeIndex == 1),
                    _DrawerLink(title: "Technical Skills", index: 2, isActive: activeIndex == 2),
                    _DrawerLink(title: "Experience", index: 3, isActive: activeIndex == 3),
                    _DrawerLink(title: "Projects", index: 4, isActive: activeIndex == 4),
                    _DrawerLink(title: "AI Productivity", index: 5, isActive: activeIndex == 5),
                    _DrawerLink(title: "Education", index: 6, isActive: activeIndex == 6),
                    _DrawerLink(title: "Client Reviews", index: 7, isActive: activeIndex == 7),
                    _DrawerLink(title: "Contact Me", index: 8, isActive: activeIndex == 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DrawerLink extends StatelessWidget {
  final String title;
  final int index;
  final bool isActive;

  const _DrawerLink({
    required this.title,
    required this.index,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isDark = controller.isDarkMode.value;

    return ListTile(
      selected: isActive,
      selectedTileColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
      leading: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isActive ? PortfolioTheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive 
              ? (isDark ? Colors.white : PortfolioTheme.primary) 
              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        controller.scrollToSection(index);
      },
    );
  }
}
