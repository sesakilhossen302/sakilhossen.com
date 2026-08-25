import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/navbar.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/experience_section.dart';
import '../sections/projects_section.dart';
import '../sections/ai_section.dart';
import '../sections/education_section.dart';
import '../sections/references_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';
import '../theme/portfolio_theme.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put PortfolioController if not already put, otherwise find
    final controller = Get.isRegistered<PortfolioController>()
        ? Get.find<PortfolioController>()
        : Get.put(PortfolioController());

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final showFab = controller.activeSectionIndex.value > 0;

      if (controller.isLoading.value && controller.profile.value == null) {
        return Scaffold(
          backgroundColor: isDark ? PortfolioTheme.bgDark : PortfolioTheme.bgLight,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(PortfolioTheme.primary),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Loading Portfolio...",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : PortfolioTheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        endDrawer: const MobileDrawer(),
        appBar: const Navbar(),
        body: Stack(
          children: [
            // 1. Dynamic Premium Background Radial Glows
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: isDark ? PortfolioTheme.bgDark : PortfolioTheme.bgLight,
              ),
            ),
            
            // Faint moving colored background circle 1
            if (isDark)
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PortfolioTheme.primary.withOpacity(0.04),
                  ),
                ),
              ),
              
            // Faint moving colored background circle 2
            if (isDark)
              Positioned(
                bottom: 200,
                right: -200,
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PortfolioTheme.accent.withOpacity(0.03),
                  ),
                ),
              ),

            // 2. Main Scroll View of Sections
            SelectionArea(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    // Section 0: Hero
                    HeroSection(
                      key: controller.sectionKeys[0],
                      onContactTap: () => controller.scrollToSection(8),
                    ),
                    // Section 1: About Me
                    AboutSection(
                      key: controller.sectionKeys[1],
                    ),
                    // Section 2: Technical Skills
                    SkillsSection(
                      key: controller.sectionKeys[2],
                    ),
                    // Section 3: Experience Timeline
                    ExperienceSection(
                      key: controller.sectionKeys[3],
                    ),
                    // Section 4: Projects Grid
                    ProjectsSection(
                      key: controller.sectionKeys[4],
                    ),
                    // Section 5: AI Productivity
                    AiSection(
                      key: controller.sectionKeys[5],
                    ),
                    // Section 6: Education
                    EducationSection(
                      key: controller.sectionKeys[6],
                    ),
                    // Section 7: Client Reviews
                    ReferencesSection(
                      key: controller.sectionKeys[7],
                    ),
                    // Section 8: Contact Form
                    ContactSection(
                      key: controller.sectionKeys[8],
                    ),
                    // Section 9: Footer
                    FooterSection(
                      key: controller.sectionKeys[9],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Smooth scroll back-to-top FAB
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showFab ? 1.0 : 0.0,
          child: showFab
              ? FloatingActionButton(
                  backgroundColor: PortfolioTheme.primary,
                  foregroundColor: Colors.white,
                  mini: true,
                  onPressed: () => controller.scrollToSection(0),
                  child: const Icon(Icons.arrow_upward_rounded),
                )
              : null,
        ),
      );
    });
  }
}
