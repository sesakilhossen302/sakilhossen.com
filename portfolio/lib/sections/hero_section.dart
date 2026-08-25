import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/portfolio_image.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onContactTap;

  const HeroSection({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveWidget.isMobile(context);
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return Obx(() {
      final profile = controller.profile.value;
      final isDark = controller.isDarkMode.value;

      final name = profile?.name ?? "";
      final title = profile?.title ?? "";
      final tagline = profile?.tagline ?? "";
      final bio = profile?.bio ?? "";
      final cvUrl = profile?.cvUrl ?? "";

      return Container(
        constraints: BoxConstraints(
          minHeight: isMobile ? size.height * 0.75 : size.height * 0.85,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? size.width * 0.08 : 24.0,
          vertical: 60.0,
        ),
        child: ResponsiveWidget(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeroGraphic(size: isMobile ? 180 : 260),
              const SizedBox(height: 40),
              _HeroTextContent(
                name: name,
                title: title,
                tagline: tagline,
                bio: bio,
                cvUrl: cvUrl,
                email: profile?.email ?? '',
                onContactTap: onContactTap,
                alignCenter: true,
                isDark: isDark,
              ),
            ],
          ),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: _HeroTextContent(
                  name: name,
                  title: title,
                  tagline: tagline,
                  bio: bio,
                  cvUrl: cvUrl,
                  email: profile?.email ?? '',
                  onContactTap: onContactTap,
                  alignCenter: false,
                  isDark: isDark,
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: HeroGraphic(
                    size: size.width * 0.22 > 320 ? size.width * 0.22 : 320,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _HeroTextContent extends StatelessWidget {
  final String name;
  final String title;
  final String tagline;
  final String bio;
  final String cvUrl;
  final String email;
  final VoidCallback onContactTap;
  final bool alignCenter;
  final bool isDark;

  const _HeroTextContent({
    required this.name,
    required this.title,
    required this.tagline,
    required this.bio,
    required this.cvUrl,
    required this.email,
    required this.onContactTap,
    required this.alignCenter,
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
    final controller = Get.find<PortfolioController>();
    final profile = controller.profile.value;
    final githubUrl = profile?.githubUrl.isNotEmpty == true
        ? profile!.githubUrl
        : '';
    final linkedinUrl = profile?.linkedinUrl.isNotEmpty == true
        ? profile!.linkedinUrl
        : '';
    final alignment = alignCenter
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = alignCenter ? TextAlign.center : TextAlign.start;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment,
      children: [
        // Welcome Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: PortfolioTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: PortfolioTheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981), // Emerald indicator
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tagline,
                style: GoogleFonts.inter(
                  color: isDark
                      ? const Color(0xFF10B981)
                      : PortfolioTheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Name Header
        Text(
          "Hey, I am",
          style: GoogleFonts.outfit(
            fontSize: alignCenter ? 24 : 32,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => PortfolioTheme.primaryGradient
              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            name,
            textAlign: textAlign,
            style: GoogleFonts.outfit(
              fontSize: alignCenter ? 46 : 64,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle / Profession
        Text(
          title,
          textAlign: textAlign,
          style: GoogleFonts.outfit(
            fontSize: alignCenter ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: PortfolioTheme.accent,
          ),
        ),
        const SizedBox(height: 20),

        // Short bio
        SizedBox(
          width: 540,
          child: Text(
            bio,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 36),

        // Action Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: alignCenter ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _AnimatedHeroButton(
              text: 'Contact Me',
              isPrimary: true,
              onPressed: onContactTap,
            ),
            _AnimatedHeroButton(
              text: 'View Projects',
              isPrimary: false,
              onPressed: () => controller.scrollToSection(4),
            ),
            _AnimatedHeroButton(
              text: 'Download CV',
              isPrimary: false,
              onPressed: () => _launchUrl(cvUrl),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Social Media Icons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialIcon(
              assetPath: 'assets/images/github-icons.png',
              url: githubUrl,
              tooltip: 'GitHub',
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              assetPath: 'assets/images/Linkedin-icons.png',
              url: linkedinUrl,
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              assetPath: 'assets/images/email-icons.webp',
              url: 'mailto:$email',
              tooltip: 'Email',
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedHeroButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _AnimatedHeroButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_AnimatedHeroButton> createState() => _AnimatedHeroButtonState();
}

class _AnimatedHeroButtonState extends State<_AnimatedHeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isDark = controller.isDarkMode.value;

    final gradient = widget.isPrimary
        ? PortfolioTheme.primaryGradient
        : const LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: gradient,
          border: widget.isPrimary
              ? null
              : Border.all(
                  color: _isHovered
                      ? PortfolioTheme.primary
                      : (isDark ? PortfolioTheme.borderDark : Colors.black26),
                  width: 1.5,
                ),
          boxShadow: widget.isPrimary && _isHovered
              ? PortfolioTheme.hoverGlowShadow
              : [],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: widget.isPrimary
                ? Colors.white
                : (isDark ? Colors.white : PortfolioTheme.secondary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final String assetPath;
  final String url;
  final String tooltip;

  const _SocialIcon({
    required this.assetPath,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch ${widget.url}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isDark = controller.isDarkMode.value;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _launchUrl,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? PortfolioTheme.primary.withOpacity(0.15)
                  : (isDark
                        ? const Color(0x0CFFFFFF)
                        : Colors.black.withOpacity(0.04)),
              shape: BoxShape.circle,
              border: Border.all(
                color: _isHovered
                    ? PortfolioTheme.primary
                    : (isDark ? PortfolioTheme.borderDark : Colors.black12),
                width: 1,
              ),
            ),
            child: Image.asset(
              widget.assetPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class HeroGraphic extends StatefulWidget {
  final double size;

  const HeroGraphic({super.key, required this.size});

  @override
  State<HeroGraphic> createState() => _HeroGraphicState();
}

class _SkillOrbitBadge {
  final String label;
  final IconData icon;
  final Color color;

  const _SkillOrbitBadge({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class HeroGraphic extends StatefulWidget {
  final double size;

  const HeroGraphic({super.key, required this.size});

  @override
  State<HeroGraphic> createState() => _HeroGraphicState();
}

class _HeroGraphicState extends State<HeroGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<_SkillOrbitBadge> outerBadges = [
    _SkillOrbitBadge(label: 'Flutter', icon: FontAwesomeIcons.flutter, color: Color(0xFF42A5F5)),
    _SkillOrbitBadge(label: 'Android', icon: FontAwesomeIcons.android, color: Color(0xFF3DDC84)),
    _SkillOrbitBadge(label: 'Firebase', icon: FontAwesomeIcons.fire, color: Color(0xFFFFCA28)),
    _SkillOrbitBadge(label: 'AI Tech', icon: Icons.auto_awesome_rounded, color: Color(0xFFA855F7)),
    _SkillOrbitBadge(label: 'REST API', icon: Icons.api_rounded, color: Color(0xFF06B6D4)),
  ];

  static const List<_SkillOrbitBadge> innerBadges = [
    _SkillOrbitBadge(label: 'Dart', icon: Icons.code_rounded, color: Color(0xFF29B6F6)),
    _SkillOrbitBadge(label: 'iOS', icon: FontAwesomeIcons.apple, color: Colors.white),
    _SkillOrbitBadge(label: 'GitHub', icon: FontAwesomeIcons.github, color: Color(0xFFFF7043)),
    _SkillOrbitBadge(label: 'GetX', icon: Icons.layers_rounded, color: Color(0xFF10B981)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 16),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final profileImg = controller.profile.value?.profileImage ?? '';
      final imgSource = profileImg.isNotEmpty
          ? profileImg
          : 'assets/images/696179481_1503014734869412_8236696213527085729_n.jpg';

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double baseAngle = _controller.value * 2 * math.pi;
          final double outerRadius = widget.size * 0.40;
          final double innerRadius = widget.size * 0.27;
          final double badgeSize = widget.size < 200 ? 32.0 : 42.0;

          final List<Widget> badgeWidgets = [];

          // 1. Outer Orbit Badges (Clockwise)
          for (int i = 0; i < outerBadges.length; i++) {
            final badge = outerBadges[i];
            final angle = baseAngle + (i * 2 * math.pi / outerBadges.length);
            final x = (widget.size / 2) + outerRadius * math.cos(angle) - (badgeSize / 2);
            final y = (widget.size / 2) + outerRadius * math.sin(angle) - (badgeSize / 2);

            badgeWidgets.add(
              Positioned(
                left: x,
                top: y,
                child: Tooltip(
                  message: badge.label,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: PortfolioTheme.surfaceDark.withOpacity(0.92),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: badge.color.withOpacity(0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: badge.color.withOpacity(0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        badge.icon,
                        size: badgeSize * 0.52,
                        color: badge.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // 2. Inner Orbit Badges (Counter-Clockwise)
          final double innerAngle = -baseAngle * 1.3;
          final double innerBadgeSize = badgeSize * 0.88;
          for (int j = 0; j < innerBadges.length; j++) {
            final badge = innerBadges[j];
            final angle = innerAngle + (j * 2 * math.pi / innerBadges.length);
            final x = (widget.size / 2) + innerRadius * math.cos(angle) - (innerBadgeSize / 2);
            final y = (widget.size / 2) + innerRadius * math.sin(angle) - (innerBadgeSize / 2);

            badgeWidgets.add(
              Positioned(
                left: x,
                top: y,
                child: Tooltip(
                  message: badge.label,
                  child: Container(
                    width: innerBadgeSize,
                    height: innerBadgeSize,
                    decoration: BoxDecoration(
                      color: PortfolioTheme.bgDark.withOpacity(0.92),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: badge.color.withOpacity(0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: badge.color.withOpacity(0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        badge.icon,
                        size: innerBadgeSize * 0.52,
                        color: badge.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Pulsating Glow
                Container(
                  width: widget.size * 0.8,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: PortfolioTheme.primary.withOpacity(0.08),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                // Custom Painter Drawing Cyber Orb Rings
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: CyberOrbPainter(
                    rotationValue: _controller.value,
                    primaryColor: PortfolioTheme.primary,
                    accentColor: PortfolioTheme.accent,
                    secondaryColor: const Color(0xFF10B981),
                  ),
                ),
                // Orbiting Tech Skill Icons
                ...badgeWidgets,
                // Center Element / Profile Image
                Container(
                  width: widget.size * 0.35,
                  height: widget.size * 0.35,
                  decoration: BoxDecoration(
                    color: PortfolioTheme.surfaceDark.withOpacity(0.85),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: PortfolioTheme.primary.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: PortfolioImage(
                      imageSource: imgSource,
                      width: widget.size * 0.35,
                      height: widget.size * 0.35,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class CyberOrbPainter extends CustomPainter {
  final double rotationValue;
  final Color primaryColor;
  final Color accentColor;
  final Color secondaryColor;

  CyberOrbPainter({
    required this.rotationValue,
    required this.primaryColor,
    required this.accentColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // 1. Draw outer rotating dashed circles
    paintLine.color = primaryColor.withOpacity(0.15);
    canvas.drawCircle(center, radius * 0.95, paintLine);

    // 2. Draw rotating constellation nodes
    final double baseAngle = rotationValue * 2 * math.pi;
    final int nodesCount = 6;

    // Outer Node Ring
    paintLine.color = primaryColor.withOpacity(0.35);
    paintLine.strokeWidth = 1.0;

    final List<Offset> outerNodes = [];
    for (int i = 0; i < nodesCount; i++) {
      final double angle = baseAngle + (i * 2 * math.pi / nodesCount);
      final double nodeRadius = radius * 0.8;
      final double x = center.dx + nodeRadius * math.cos(angle);
      final double y = center.dy + nodeRadius * math.sin(angle);
      final nodePos = Offset(x, y);
      outerNodes.add(nodePos);

      // Draw glow ring node
      final nodePaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(nodePos, 4, nodePaint);
      canvas.drawCircle(
        nodePos,
        8,
        Paint()
          ..color = primaryColor.withOpacity(0.15)
          ..style = PaintingStyle.fill,
      );
    }

    // Inner Node Ring (rotates in opposite direction)
    paintLine.color = accentColor.withOpacity(0.35);
    final double innerAngle = -baseAngle * 1.5;
    final List<Offset> innerNodes = [];
    for (int i = 0; i < nodesCount; i++) {
      final double angle = innerAngle + (i * 2 * math.pi / nodesCount);
      final double nodeRadius = radius * 0.55;
      final double x = center.dx + nodeRadius * math.cos(angle);
      final double y = center.dy + nodeRadius * math.sin(angle);
      final nodePos = Offset(x, y);
      innerNodes.add(nodePos);

      final nodePaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(nodePos, 3, nodePaint);
      canvas.drawCircle(
        nodePos,
        6,
        Paint()
          ..color = accentColor.withOpacity(0.15)
          ..style = PaintingStyle.fill,
      );
    }

    // Connect nodes with thin network lines
    final linePaint = Paint()
      ..color = primaryColor.withOpacity(0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (var outer in outerNodes) {
      for (var inner in innerNodes) {
        final dist = (outer - inner).distance;
        if (dist < radius * 0.8) {
          canvas.drawLine(outer, inner, linePaint);
        }
      }
    }

    // 3. Draw orbital sweep ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromCircle(center: center, radius: radius * 0.7);
    final gradient = SweepGradient(
      colors: [primaryColor, accentColor, secondaryColor, primaryColor],
      stops: const [0.0, 0.35, 0.7, 1.0],
      transform: GradientRotation(baseAngle),
    );

    ringPaint.shader = gradient.createShader(rect);
    canvas.drawArc(rect, 0, 2 * math.pi, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CyberOrbPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
