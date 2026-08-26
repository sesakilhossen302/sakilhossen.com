import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/portfolio_theme.dart';

class PortfolioImage extends StatelessWidget {
  final String imageSource;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;

  const PortfolioImage({
    super.key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final source = imageSource.trim();
    if (source.isEmpty) {
      return _buildFallback();
    }

    // 1. Data URI or Web URL
    if (source.startsWith('data:image') || source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (source.startsWith('data:image')) {
            try {
              final cleanBase64 = _getCleanBase64(source);
              Uint8List bytes;
              try {
                bytes = base64Decode(cleanBase64);
              } catch (_) {
                bytes = base64Url.decode(cleanBase64);
              }
              return Image.memory(
                bytes,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (_, __, ___) => _buildFallback(),
              );
            } catch (_) {
              return _buildFallback();
            }
          }
          return _buildFallback();
        },
      );
    }

    // 2. Raw base64 string
    if (_isBase64(source)) {
      try {
        final cleanBase64 = _getCleanBase64(source);
        Uint8List bytes;
        try {
          bytes = base64Decode(cleanBase64);
        } catch (_) {
          bytes = base64Url.decode(cleanBase64);
        }
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      } catch (e) {
        return _buildFallback();
      }
    }

    // 3. Fallback to Asset Image
    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: PortfolioTheme.primaryGradient,
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          color: Colors.white70,
          size: width != null ? width! * 0.25 : 32,
        ),
      ),
    );
  }

  bool _isBase64(String str) {
    String clean = str.trim().replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 20) return false; // Base64 image strings are always longer
    if (clean.contains(',')) {
      clean = clean.split(',')[1];
    }
    final remainder = clean.length % 4;
    if (remainder != 0) {
      clean = clean + '=' * (4 - remainder);
    }
    final regex = RegExp(r'^[a-zA-Z0-9+/=_-]+$');
    return regex.hasMatch(clean);
  }

  String _getCleanBase64(String str) {
    String clean = str.trim();
    if (clean.contains(',')) {
      clean = clean.split(',')[1];
    }
    clean = clean.replaceAll(RegExp(r'\s+'), '');
    final remainder = clean.length % 4;
    if (remainder != 0) {
      clean = clean + '=' * (4 - remainder);
    }
    return clean;
  }
}
