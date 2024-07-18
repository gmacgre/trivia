import 'package:flutter/material.dart';
import 'package:trivia/pages/answer/answers.dart';
import 'package:trivia/pages/menu/landing.dart';
import 'package:trivia/pages/menu/load.dart';
import 'package:trivia/pages/menu/new.dart';
import 'package:trivia/pages/menu/settings.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (args.firstOrNull == 'multi_window') {
    runApp(AnswersWindow(trivia: args[2]));
  }
  else {
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

    runApp(const MainWindow());
  }
}

class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'TriviaApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routes: {
        '/': (context) => const LandingPage(),
        '/new': (context) => const NewTriviaPage(),
        '/load': (context) => const LoadTriviaPage(), 
        '/settings': (context) => const SettingsPage()
      },
    );
  }
}


class AnswersWindow extends StatelessWidget {

  final String trivia;

  const AnswersWindow({
    required this.trivia,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Answers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: AnswersPage(trivia: trivia),

    );
  }
}