import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/portfolio_controller.dart';
import '../theme/portfolio_theme.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/portfolio_image.dart';

class ReferencesSection extends StatelessWidget {
  const ReferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final size = MediaQuery.of(context).size;
    final isDark = controller.isDarkMode.value;
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return Obx(() {
      final referencesList = controller.references;
      if (referencesList.isEmpty) return const SizedBox();

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
                  'Client Reviews',
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
              "What tech leads and clients say about collaborating with me:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),

            // Responsive testimonial cards list/grid
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                int crossAxisCount = 1;
                if (width >= 900) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: referencesList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    mainAxisExtent: 270, // Height allowing review screenshot proof preview
                  ),
                  itemBuilder: (context, index) {
                    final ref = referencesList[index];
                    return _TestimonialCard(
                      name: ref.clientName,
                      company: ref.clientCompany,
                      comment: ref.clientComment,
                      rating: ref.clientRating,
                      image: ref.clientImage,
                      reviewImage: ref.reviewImage,
                      isDark: isDark,
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
}

class _TestimonialCard extends StatefulWidget {
  final String name;
  final String company;
  final String comment;
  final double rating;
  final String image;
  final String reviewImage;
  final bool isDark;

  const _TestimonialCard({
    required this.name,
    required this.company,
    required this.comment,
    required this.rating,
    required this.image,
    required this.reviewImage,
    required this.isDark,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  void _showProofDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight,
              width: 1.5,
            ),
            boxShadow: PortfolioTheme.premiumShadow(widget.isDark),
          ),
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 700,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.name}'s Review Screenshot Proof",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: widget.isDark ? Colors.white70 : PortfolioTheme.secondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    child: PortfolioImage(
                      imageSource: widget.reviewImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasProof = widget.reviewImage.trim().isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_isHovered 
                  ? PortfolioTheme.primary.withOpacity(0.05) 
                  : PortfolioTheme.surfaceDark.withOpacity(0.4))
              : (_isHovered 
                  ? PortfolioTheme.primary.withOpacity(0.02) 
                  : PortfolioTheme.surfaceLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? PortfolioTheme.primary.withOpacity(0.5)
                : (widget.isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight),
            width: 1.5,
          ),
          boxShadow: _isHovered 
              ? PortfolioTheme.hoverGlowShadow 
              : (widget.isDark ? [] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Comment text
            Expanded(
              child: Text(
                '"${widget.comment}"',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic,
                  color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  height: 1.45,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),

            // 2. Review Proof Screenshot Bar (if available)
            if (hasProof) ...[
              InkWell(
                onTap: () => _showProofDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0x1AFFFFFF) : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PortfolioTheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 44,
                          height: 32,
                          child: PortfolioImage(
                            imageSource: widget.reviewImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  "Review Proof Screenshot",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Click to zoom full image 🔍",
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: PortfolioTheme.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.zoom_in_rounded, size: 18, color: PortfolioTheme.accent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // 3. Client Profile Details Row
            Row(
              children: [
                // Avatar image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: PortfolioTheme.accent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: PortfolioImage(
                      imageSource: widget.image,
                      fallbackIcon: Icons.person_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.company,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: widget.isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating stars
                Row(
                  children: List.generate(5, (index) {
                    final starVal = index + 1;
                    if (widget.rating >= starVal) {
                      return const Icon(Icons.star_rounded, color: Colors.amber, size: 15);
                    } else if (widget.rating >= starVal - 0.5) {
                      return const Icon(Icons.star_half_rounded, color: Colors.amber, size: 15);
                    } else {
                      return Icon(Icons.star_border_rounded, color: Colors.grey.shade400, size: 15);
                    }
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
