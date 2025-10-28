// navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  // GlobalKey to access the navigator state
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Push to a new screen
  static Future<dynamic> push(Widget screen) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Replace current screen
  static Future<dynamic> pushReplacement(Widget screen) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Clear all screens and start fresh
  static void pushAndRemoveUntil(Widget screen) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  // Go back
  static void pop() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }

  static void popUntilRoot() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  static void goBack<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }
}
