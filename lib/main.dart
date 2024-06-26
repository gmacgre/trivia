import 'package:flutter/material.dart';
import 'package:trivia/pages/landing.dart';
import 'package:trivia/pages/new_trivia.dart';
import 'package:trivia/pages/settings.dart';
import 'package:window_manager/window_manager.dart';

void main() async {

  // Code to make the application fullscreen on sta
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 700),
    backgroundColor: Colors.transparent,
    center: true,
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'TriviaApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
      ),
      routes: {
        '/': (context) => const LandingPage(),
        '/new': (context) => const NewTriviaPage(), 
        '/settings': (context) => const SettingsPage()
      },
    );
  }
}