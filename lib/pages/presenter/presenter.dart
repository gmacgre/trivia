import 'package:audioplayers/audioplayers.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/bowl_section.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/pages/presenter/bowl_presenter.dart';
import 'package:trivia/pages/presenter/jeopardy_presenter.dart';

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
  int _selectedSection = -1;
  late Widget toPresent = const Placeholder();
  final JeopardyPresenterController _jeopardyController = JeopardyPresenterController();

  @override
  void initState() {
    super.initState();

    // Build Audio and Window Management
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
    Widget finalPresenter = toPresent;
    if(_selectedSection == -1) {
      finalPresenter = Icon(
        Icons.lightbulb,
        size: MediaQuery.of(context).size.height / 2,
        color: Theme.of(context).primaryColor,
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 14,
            child: finalPresenter
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _players.map((e) => Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        e.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${e.score}',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
        ] 
      )
    );
  }


  // This is where all Controller methods are initially processed
  void _processMessage(String method, dynamic arguments) {
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
      case 'launchSection': {
        setState(() {
          _selectedSection = arguments as int;
          toPresent = switch (widget.trivia.sections[_selectedSection].runtimeType) {
            JeopardySection => JeopardyPresenter(
              controller: _jeopardyController,
              section: widget.trivia.sections[_selectedSection] as JeopardySection
            ),
            BowlSection => const BowlPresenter(
            ),
            // Should never reach here
            _ => const Placeholder(),
          };
        });
      }
      case 'sections': {
        setState(() {
          _selectedSection = -1;
        });
      }
      case 'jeopardyShowQuestion': {
        _jeopardyController.showQuestion(arguments['category'], arguments['question']);
      }
      case 'jeopardyShowBoard': {
        _jeopardyController.showBoard();
      }
    }
  }
}