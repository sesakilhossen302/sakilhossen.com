import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

typedef VisibilityCallback = void Function(bool isHidden);

class TabVisibilityHelper {
  static StreamSubscription? _sub;
  static StreamSubscription? _blurSub;
  static StreamSubscription? _focusSub;

  static void listen(VisibilityCallback onChange) {
    stop();
    try {
      _sub = html.document.onVisibilityChange.listen((_) {
        final isHidden = html.document.hidden ?? false;
        onChange(isHidden);
      });

      _blurSub = html.window.onBlur.listen((_) {
        onChange(true);
      });

      _focusSub = html.window.onFocus.listen((_) {
        final isHidden = html.document.hidden ?? false;
        onChange(isHidden);
      });
    } catch (e) {}
  }

  static void stop() {
    _sub?.cancel();
    _blurSub?.cancel();
    _focusSub?.cancel();
    _sub = null;
    _blurSub = null;
    _focusSub = null;
  }
}
