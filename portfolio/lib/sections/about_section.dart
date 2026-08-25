import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/responsive_widget.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveWidget.isMobile(context);
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return Obx(() {
      final profile = controller.profile.value;
      final isDark = controller.isDarkMode.value;

      final bio = profile?.bio ?? "";
      final philosophy = profile?.developmentPhilosophy ?? "";
      final goals = profile?.careerGoals ?? "";

      final expYears = profile?.experienceYears ?? "";
      final completedProj = profile?.completedProjects ?? "";
      final clientsCount = profile?.happyClients ?? "";

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
                  'About Me',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : PortfolioTheme.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            ResponsiveWidget(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutStoryText(
                    bio: bio,
                    philosophy: philosophy,
                    goals: goals,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 40),
                  _AboutStatsGrid(
                    exp: expYears,
                    proj: completedProj,
                    clients: clientsCount,
                    isDark: isDark,
                  ),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _AboutStoryText(
                      bio: bio,
                      philosophy: philosophy,
                      goals: goals,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: size.width * 0.08),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: _AboutStatsGrid(
                        exp: expYears,
                        proj: completedProj,
                        clients: clientsCount,
                        isDark: isDark,
                        verticalLayout: true,
                      ),
                    ),
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

class _AboutStoryText extends StatelessWidget {
  final String bio;
  final String philosophy;
  final String goals;
  final bool isDark;

  const _AboutStoryText({
    required this.bio,
    required this.philosophy,
    required this.goals,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Designing beautiful applications that solve real-world problems.",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : PortfolioTheme.secondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Text(bio, style: textTheme.bodyLarge),
        const SizedBox(height: 16),

        Text(
          "Development Philosophy",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: PortfolioTheme.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(philosophy, style: textTheme.bodyLarge),
        const SizedBox(height: 16),

        Text(
          "Career Goals",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: PortfolioTheme.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(goals, style: textTheme.bodyLarge),
      ],
    );
  }
}

class _AboutStatsGrid extends StatelessWidget {
  final String exp;
  final String proj;
  final String clients;
  final bool isDark;
  final bool verticalLayout;

  const _AboutStatsGrid({
    required this.exp,
    required this.proj,
    required this.clients,
    required this.isDark,
    this.verticalLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    if (verticalLayout) {
      return Column(
        children: [
          _StatCard(number: exp, label: 'Years of Experience', isDark: isDark),
          const SizedBox(height: 20),
          _StatCard(number: proj, label: 'Projects Completed', isDark: isDark),
          const SizedBox(height: 20),
          _StatCard(number: clients, label: 'Happy Clients', isDark: isDark),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 32) / 3;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(
              number: exp,
              label: 'Years of\nExperience',
              width: itemWidth > 100 ? itemWidth : double.infinity,
              isDark: isDark,
            ),
            _StatCard(
              number: proj,
              label: 'Projects\nCompleted',
              width: itemWidth > 100 ? itemWidth : double.infinity,
              isDark: isDark,
            ),
            _StatCard(
              number: clients,
              label: 'Happy\nClients',
              width: itemWidth > 100 ? itemWidth : double.infinity,
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final String number;
  final String label;
  final double? width;
  final bool isDark;

  const _StatCard({
    required this.number,
    required this.label,
    this.width,
    required this.isDark,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_isHovered
                    ? PortfolioTheme.primary.withOpacity(0.06)
                    : PortfolioTheme.surfaceDark.withOpacity(0.4))
              : (_isHovered
                    ? PortfolioTheme.primary.withOpacity(0.04)
                    : PortfolioTheme.surfaceLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? PortfolioTheme.primary.withOpacity(0.4)
                : (widget.isDark
                      ? PortfolioTheme.borderDark
                      : PortfolioTheme.borderLight),
            width: 1.2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: PortfolioTheme.primary.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : (widget.isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  PortfolioTheme.primaryGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: Text(
                widget.number,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF475569),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
