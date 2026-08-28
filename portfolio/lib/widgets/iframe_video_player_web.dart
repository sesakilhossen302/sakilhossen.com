// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class IframeVideoPlayer extends StatefulWidget {
  final String embedUrl;
  final bool allowInteraction;

  const IframeVideoPlayer({
    super.key,
    required this.embedUrl,
    this.allowInteraction = false,
  });

  @override
  State<IframeVideoPlayer> createState() => _IframeVideoPlayerState();
}

class _IframeVideoPlayerState extends State<IframeVideoPlayer> {
  late String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'iframe-${widget.embedUrl.hashCode}-${widget.allowInteraction}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int id) {
        final iframe = html.IFrameElement()
          ..src = widget.embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow = 'autoplay; encrypted-media; fullscreen; picture-in-picture';

        if (!widget.allowInteraction) {
          iframe.style.pointerEvents = 'none';
        } else {
          iframe.style.pointerEvents = 'auto';
        }
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
