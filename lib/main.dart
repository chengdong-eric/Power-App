import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:power/firebase_options.dart';
import 'package:power/screens/main_nav_screen.dart';
import 'package:power/theme/app_theme.dart';
import 'package:power/widgets/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PowerApp());
}

class PowerApp extends StatelessWidget {
  const PowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
