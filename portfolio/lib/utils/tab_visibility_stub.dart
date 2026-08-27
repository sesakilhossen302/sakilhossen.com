typedef VisibilityCallback = void Function(bool isHidden);

class TabVisibilityHelper {
  static void listen(VisibilityCallback onChange) {}
  static void stop() {}
}
