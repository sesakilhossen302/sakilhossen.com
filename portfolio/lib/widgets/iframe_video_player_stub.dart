import 'package:flutter/material.dart';

class IframeVideoPlayer extends StatelessWidget {
  final String embedUrl;
  final bool allowInteraction;

  const IframeVideoPlayer({
    super.key,
    required this.embedUrl,
    this.allowInteraction = false,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
