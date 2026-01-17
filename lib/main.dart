import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/chat_screen.dart'; // ← ADD THIS

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb
        ? DefaultFirebaseOptions.web
        : DefaultFirebaseOptions.android,
  );

  runApp(const LawScribeApp());
}

class LawScribeApp extends StatelessWidget {
  const LawScribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,

          initialRoute: '/',

          routes: {
            '/': (_) => const SplashScreen(),
            '/home': (_) => const ChatScreen(), // ← make ChatScreen const
            '/login': (_) => const LoginScreen(),
            '/signup': (_) => const SignupScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
