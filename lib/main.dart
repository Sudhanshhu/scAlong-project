import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wire up the dependency graph (core services, repositories, cubits).
  setupServiceLocator();

  runApp(const App());
}
