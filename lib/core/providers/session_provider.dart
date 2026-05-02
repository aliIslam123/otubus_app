import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;

  /// Initialize session (could load from storage if needed)
  Future<void> initializeSession() async {
    try {
      // In a real app, you'd check shared_preferences for saved session
      // For now, we start as logged out
      _isLoggedIn = false;
      _userEmail = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing session: $e');
    }
  }

  /// Set user as logged in (called from login screen)
  void setLoggedIn(String? email) {
    _isLoggedIn = true;
    _userEmail = email;
    notifyListeners();
  }

  /// Clear user session and logout
  Future<void> logout() async {
    try {
      // Clear any saved session data
      _isLoggedIn = false;
      _userEmail = null;
      notifyListeners();

      // In a real app, you'd clear SharedPreferences here
      // and also invalidate any auth tokens
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
