// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables before anything else
  await dotenv.load(fileName: '.env');

  // Initialise SharedPreferences (favorites persistence)
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}
