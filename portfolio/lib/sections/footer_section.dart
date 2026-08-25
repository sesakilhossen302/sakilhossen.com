import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

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
    final isDark = controller.isDarkMode.value;
    final profile = controller.profile.value;
    final email = profile?.email ?? '';
    final githubUrl = profile?.githubUrl.isNotEmpty == true
        ? profile!.githubUrl
        : 'https://github.com/sakil';
    final linkedinUrl = profile?.linkedinUrl.isNotEmpty == true
        ? profile!.linkedinUrl
        : 'https://linkedin.com';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F1D) : const Color(0xFFE2E8F0),
        border: Border(
          top: BorderSide(
            color: isDark
                ? PortfolioTheme.borderDark
                : PortfolioTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Branding Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sakil Hossen",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : PortfolioTheme.secondary,
                ),
              ),
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(left: 4, top: 8),
                decoration: const BoxDecoration(
                  color: PortfolioTheme.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Flutter Mobile Application Developer | Clean Architecture Specialist",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // Social Icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterSocialButton(
                assetPath: 'assets/images/github-icons.png',
                onPressed: () => _launchUrl(githubUrl),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _FooterSocialButton(
                assetPath: 'assets/images/Linkedin-icons.png',
                onPressed: () => _launchUrl(linkedinUrl),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _FooterSocialButton(
                assetPath: 'assets/images/email-icons.webp',
                onPressed: () => _launchUrl(
                  email.isNotEmpty
                      ? 'mailto:$email'
                      : 'mailto:sakil@example.com',
                ),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Divider(height: 1, indent: 40, endIndent: 40),
          const SizedBox(height: 24),

          // Copyright details
          Text(
            "© 2026 Sakil Hossen. All Rights Reserved.",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSocialButton extends StatefulWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final bool isDark;

  const _FooterSocialButton({
    required this.assetPath,
    required this.onPressed,
    required this.isDark,
  });

  @override
  State<_FooterSocialButton> createState() => _FooterSocialButtonState();
}

class _FooterSocialButtonState extends State<_FooterSocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? PortfolioTheme.primary.withOpacity(0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? PortfolioTheme.primary
                  : (widget.isDark ? Colors.white10 : Colors.black12),
              width: 1,
            ),
          ),
          child: Image.asset(
            widget.assetPath,
            width: 16,
            height: 16,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
