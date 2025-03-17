import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/scheme_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/submit_application.dart';
import 'screens/track_status.dart';
import 'screens/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final Brightness brightness = MediaQuery.of(context).platformBrightness;
          themeProvider.updateSystemTheme(brightness);
        });
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Panchayat Raj App',
          theme: themeProvider.currentTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/home': (context) => const HomeScreen(),
            '/submit_application': (context) => const SubmitApplicationScreen(),
            '/track_status': (context) => const TrackStatusScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/profile_screen': (context) => Profile(),
            '/schemes': (context) => SchemeListPage(),
          },
        );
      },
    );
  }
}