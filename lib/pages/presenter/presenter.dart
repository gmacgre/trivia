import 'package:audioplayers/audioplayers.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/trivia.dart';

class PresenterPage extends StatefulWidget {
  const PresenterPage({
    required this.trivia,
    super.key
  });

  final Trivia trivia;

  @override
  State<PresenterPage> createState() => _PresenterPageState();
}

class _PresenterPageState extends State<PresenterPage> {
  late final WindowController window;
  late AudioPlayer _audio = AudioPlayer();
  final List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _audio = AudioPlayer();
    _audio.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audio.setSource(AssetSource('times-up.mp3'));
    });
    DesktopMultiWindow.createWindow(FileManager.encode(widget.trivia)).then((value) => setState((){
      window = value;
      window 
      ..setFrame(const Offset(0, 0) & const Size(1200, 850))
      ..center()
      ..setTitle('Controller Window')
      ..show();
    }));
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      _processMessage(call.method, call.arguments);
    });
  }

  @override
  void dispose() {
    window.close();
    _audio.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.lightbulb,
          size: MediaQuery.of(context).size.height / 2,
          color: Theme.of(context).primaryColor,
        ),
      )
    );
  }

  void _processMessage(String method, dynamic arguments) {
    // Just Blind access what we want, sadly no good way to typecheck
    switch (method) {
      case 'newPlayer': {
        setState(() {
          _players.add(
            Player(
              score: arguments['score'],
              name: arguments['name']
            )
          );
        });
      }
      case 'setName': {
        setState(() {
          _players[arguments['index']].name = arguments['name'];
        });
      }
      case 'setScore': {
        setState(() {
          _players[arguments['index']].score = arguments['score'];
        });
      }
      case 'buzz': {
        _audio.resume();
      }
      case 'pop': {
        Navigator.of(context).pop();
      }
    }
  }
}