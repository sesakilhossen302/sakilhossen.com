import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../theme/portfolio_theme.dart';
import 'portfolio_image.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isDark;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
          decoration: BoxDecoration(
            color: widget.isDark 
                ? (_isHovered 
                    ? PortfolioTheme.surfaceDark 
                    : PortfolioTheme.surfaceDark.withOpacity(0.4))
                : (_isHovered 
                    ? PortfolioTheme.surfaceLight 
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
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Project Image on top (Clips to card corners)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PortfolioImage(
                          imageSource: project.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (project.videoUrl != null && project.videoUrl!.trim().isNotEmpty)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: PortfolioTheme.primary.withOpacity(0.6), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_circle_fill_rounded, color: PortfolioTheme.primary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  "Video",
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // 2. Project Title and tags below
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : PortfolioTheme.secondary,
                        ),
                      ),
                      
                      const SizedBox(height: 6),
                      // Short Description
                      Expanded(
                        child: Text(
                          project.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            height: 1.4,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      // Tags Wrap
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: project.tags.take(3).map((tag) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.isDark 
                                    ? const Color(0x0CFFFFFF) 
                                    : Colors.black.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: widget.isDark ? PortfolioTheme.borderDark : PortfolioTheme.borderLight, 
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: PortfolioTheme.accent,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
}
