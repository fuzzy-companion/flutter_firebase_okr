import 'package:flutter/material.dart';

class NavigationHelper {
  // Global navigator key (VERY useful for Bloc/navigation outside UI)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // ─── BASIC NAVIGATION ─────────────────────────────────────────────

  static Future<T?> push<T>(Widget page) {
    FocusManager.instance.primaryFocus?.unfocus();

    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> pushReplacement<T, TO>(Widget page) {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget page) {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static void pop<T>([T? result]) {
    FocusManager.instance.primaryFocus?.unfocus();
    navigatorKey.currentState!.pop(result);
  }

  // ─── NAMED ROUTES (OPTIONAL) ──────────────────────────────────────

  static Future<T?> pushNamed<T>(String route, {Object? arguments}) {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T, TO>(
    String route, {
    Object? arguments,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState!.pushReplacementNamed(
      route,
      arguments: arguments,
    );
  }
}
