// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class StorageHelper {
  static const String _tokenKey = 'admin_auth_token';

  static void saveToken(String token) {
    try {
      html.window.localStorage[_tokenKey] = token;
    } catch (e) {}
  }

  static String? getToken() {
    try {
      final token = html.window.localStorage[_tokenKey];
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      return null;
    }
  }

  static void clearToken() {
    try {
      html.window.localStorage.remove(_tokenKey);
    } catch (e) {}
  }
}
