import 'package:flutter/material.dart';

extension ContextNavigationX on BuildContext {
  NavigatorState get nav => Navigator.of(this);
}

extension NavigatorStateX on NavigatorState {
  Future<T?> jump<T>(Route<T> newRoute) => pushAndRemoveUntil(newRoute, (_) => false);
}
