import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/portfolio_controller.dart';
import '../models/project_model.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/portfolio_image.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final size = MediaQuery.of(context).size;
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return Obx(() {
      final projects = controller.projects;
      if (projects.isEmpty) return const SizedBox();
      final isDark = controller.isDarkMode.value;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? size.width * 0.08 : 24.0,
          vertical: 80.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: PortfolioTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Featured Projects',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : PortfolioTheme.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Some of my mobile applications and platforms. Click on any project to view details:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            
            // Projects Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                int crossAxisCount = 1;
                if (width >= 900) {
                  crossAxisCount = 3;
                } else if (width >= 600) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 28,
                    mainAxisExtent: 340, // Uniform height for the project cards
                  ),
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ProjectCard(
                      project: project,
                      isDark: isDark,
                      onTap: () => _showProjectDetailsDialog(context, project, isDark),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  void _showProjectDetailsDialog(BuildContext context, Project project, bool isDark) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: _ProjectDetailsModal(project: project, isDark: isDark),
          ),
        );
      },
    );
  }
}

class _ProjectDetailsModal extends StatelessWidget {
  final Project project;
  final bool isDark;

  const _ProjectDetailsModal({
    required this.project,
    required this.isDark,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveWidget.isMobile(context);

    // Conditional indicators
    final bool hasPlayStore = project.playStoreUrl != null && project.playStoreUrl!.trim().isNotEmpty;
    final bool hasAppStore = project.appStoreUrl != null && project.appStoreUrl!.trim().isNotEmpty;
    final bool hasGitHub = project.githubUrl != null && project.githubUrl!.trim().isNotEmpty;

    return Container(
      width: isMobile ? size.width * 0.9 : 860,
      constraints: BoxConstraints(
        maxHeight: size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? PortfolioTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight,
          width: 1.5,
        ),
        boxShadow: PortfolioTheme.premiumShadow(isDark),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button floating or header
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : PortfolioTheme.secondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                child: ResponsiveWidget(
                  mobile: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageWidget(),
                      const SizedBox(height: 24),
                      _buildTextContent(context, hasPlayStore, hasAppStore, hasGitHub),
                    ],
                  ),
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildImageWidget(),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 6,
                        child: _buildTextContent(context, hasPlayStore, hasAppStore, hasGitHub),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight,
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: PortfolioImage(
          imageSource: project.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, bool hasPlayStore, bool hasAppStore, bool hasGitHub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          project.title,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : PortfolioTheme.secondary,
          ),
        ),
        const SizedBox(height: 12),
        
        // Tags Wrap
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0x0CFFFFFF) : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PortfolioTheme.accent,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        
        // About Section
        Text(
          "About the Project",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : PortfolioTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          project.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        
        // Key Features Checklist
        if (project.features.isNotEmpty) ...[
          Text(
            "Key Features",
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : PortfolioTheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          ...project.features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF10B981), // Emerald green check
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
        ],
        
        // Conditional Render of Buttons
        if (hasPlayStore || hasAppStore || hasGitHub) ...[
          Text(
            "Links & Downloads",
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Google Play Store
              if (hasPlayStore)
                _buildLinkButton(
                  label: "Google Play",
                  icon: Icons.shop_two_rounded,
                  color: const Color(0xFF34A853), // Google Green
                  onPressed: () => _launchUrl(project.playStoreUrl!),
                ),
              // Apple App Store
              if (hasAppStore)
                _buildLinkButton(
                  label: "App Store",
                  icon: Icons.apple_rounded,
                  color: Colors.black, // Apple Black
                  onPressed: () => _launchUrl(project.appStoreUrl!),
                ),
              // GitHub Link
              if (hasGitHub)
                _buildLinkButton(
                  label: "GitHub Source",
                  icon: Icons.code_rounded,
                  color: PortfolioTheme.primary, // Brand primary
                  onPressed: () => _launchUrl(project.githubUrl!),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLinkButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
