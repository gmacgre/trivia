import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TRIVIA APP',
                style: Theme.of(context).textTheme.headlineLarge
              ),
              SizedBox(height: constraints.maxHeight * 0.1,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(onPressed: () => { _launch('/new')}, child: const Text('New Trivia')),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(onPressed: () => { _launch('/settings')}, child: const Text('Load Trivia')),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(onPressed: () => { _launch('/settings')}, child: const Text('Settings')),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(onPressed: () => {WindowManager.instance.close()}, child: const Text('Exit')),
              ),
            ]
          ),
        ),
      ),
    );
  }
  
  void _launch(String route) {
    Navigator.of(context).pushNamed(route);
  }
}