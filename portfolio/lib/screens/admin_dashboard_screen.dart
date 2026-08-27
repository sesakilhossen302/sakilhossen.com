import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';
import 'admin/widgets/admin_sidebar.dart';
import 'admin/widgets/admin_stats_header.dart';
import 'admin/tabs/admin_inbox_tab.dart';
import 'admin/tabs/admin_profile_identity_tab.dart';
import 'admin/tabs/admin_contact_links_tab.dart';
import 'admin/tabs/admin_hero_video_tab.dart';
import 'admin/tabs/admin_bio_stats_tab.dart';
import 'admin/tabs/admin_security_tab.dart';
import 'admin/tabs/admin_projects_tab.dart';
import 'admin/tabs/admin_reviews_tab.dart';
import 'admin/tabs/admin_education_tab.dart';
import 'admin/tabs/admin_experience_tab.dart';
import 'admin/tabs/admin_skills_tab.dart';
import 'admin/tabs/admin_ai_workflow_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTabIndex = 0;
  final adminController = Get.find<AdminController>();
  final portfolioController = Get.find<PortfolioController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Redirect if not logged in
      if (!adminController.isLoggedIn.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed('/admin');
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final isDark = portfolioController.isDarkMode.value;
      final isDesktop = MediaQuery.of(context).size.width >= 768;

      final tabViews = [
        AdminInboxTab(isDark: isDark),
        AdminProfileIdentityTab(isDark: isDark),
        AdminContactLinksTab(isDark: isDark),
        AdminHeroVideoTab(isDark: isDark),
        AdminBioStatsTab(isDark: isDark),
        AdminSecurityTab(isDark: isDark),
        AdminProjectsTab(isDark: isDark),
        AdminReviewsTab(isDark: isDark),
        AdminEducationTab(isDark: isDark),
        AdminExperienceTab(isDark: isDark),
        AdminSkillsTab(isDark: isDark),
        AdminAiWorkflowTab(isDark: isDark),
      ];

      return Scaffold(
        backgroundColor: isDark ? PortfolioTheme.bgDark : PortfolioTheme.bgLight,
        drawer: !isDesktop
            ? Drawer(
                child: AdminSidebar(
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  isDark: isDark,
                  isDrawer: true,
                ),
              )
            : null,
        appBar: AppBar(
          backgroundColor: isDark ? PortfolioTheme.surfaceDark : Colors.white,
          elevation: 1,
          leading: !isDesktop
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )
              : null,
          title: Text(
            AdminSidebar.menuItems[_selectedTabIndex]['label'] as String,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : PortfolioTheme.secondary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.yellowAccent : PortfolioTheme.secondary,
              ),
              onPressed: portfolioController.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              tooltip: "Logout",
              onPressed: () {
                adminController.logout();
                Get.offNamed('/');
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          children: [
            // Left Sidebar for Desktop Screens
            if (isDesktop)
              AdminSidebar(
                selectedIndex: _selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                isDark: isDark,
              ),

            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top Stats Summary Cards
                  Padding(
                    padding: EdgeInsets.only(
                      left: isDesktop ? 24 : 0,
                      right: isDesktop ? 24 : 0,
                      top: isDesktop ? 24 : 12,
                    ),
                    child: AdminStatsHeader(
                      isDark: isDark,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                  ),

                  // Mobile Fast Tab Pills Bar for Mobile Screens
                  if (!isDesktop)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: List.generate(AdminSidebar.menuItems.length, (index) {
                          final item = AdminSidebar.menuItems[index];
                          final isSelected = _selectedTabIndex == index;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(item['label'] as String),
                              selected: isSelected,
                              selectedColor: PortfolioTheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedTabIndex = index;
                                  });
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                  // Active Tab Workspace Body
                  Expanded(
                    child: tabViews[_selectedTabIndex],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
