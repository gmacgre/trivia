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
    // Create the audio player.
    _audio = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    _audio.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
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


  // This is just a basic cover that is the main listener for prompts from the anser board
  // Just show a default logo for now on the front
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trivia.title),
        centerTitle: true,
      ),
      body: const Placeholder()
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
      case 'showBoard': {
        _audio.resume();
      }
    }
  }
}