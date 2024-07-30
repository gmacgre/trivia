import 'package:audioplayers/audioplayers.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/bowl_section.dart';
import 'package:trivia/model/section/final_section.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/multianswer_section.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/pages/presenter/bowl_presenter.dart';
import 'package:trivia/pages/presenter/final_question_presenter.dart';
import 'package:trivia/pages/presenter/jeopardy_presenter.dart';
import 'package:trivia/pages/presenter/multi_presenter.dart';

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
  late AudioPlayer _longAudio;
  late AudioPlayer _shortAudio;
  final List<Player> _players = [];
  int _selectedSection = -1;
  late Widget toPresent = const Placeholder();
  final JeopardyPresenterController _jeopardyController = JeopardyPresenterController();
  final FinalQuestionPresenterController _finalController = FinalQuestionPresenterController();
  final MultiAnswerPresenterController _multiController = MultiAnswerPresenterController();
  @override
  void initState() {
    super.initState();

    // Build Audio and Window Management
    _longAudio = AudioPlayer();
    _shortAudio = AudioPlayer();

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
    _longAudio.dispose();
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
                        style: Theme.of(context).textTheme.displaySmall,
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
  void _processMessage(String method, dynamic arguments) async {
    switch (method) {
      // Player Management Calls
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

      // Sound Calls
      case 'buzz': {
        _shortAudio.setSource(AssetSource('times-up.mp3')).then((value) => _shortAudio.resume());
      }
      case 'theme': {
        _longAudio.setSource(AssetSource('jeopardy-theme.mp3')).then((value) => _longAudio.resume());
      }

      // End Presenting
      case 'pop': {
        Navigator.of(context).pop();
      }

      // Section Calls
      case 'launchSection': {
        _selectedSection = arguments as int;
        if(widget.trivia.sections[_selectedSection] is JeopardySection) {
          await _longAudio.setSource(AssetSource('fill.mp3'));
          _longAudio.resume();
        }
        setState(() {
          _selectedSection = _selectedSection;
          toPresent = switch (widget.trivia.sections[_selectedSection].runtimeType) {
            JeopardySection => JeopardyPresenter(
              controller: _jeopardyController,
              section: widget.trivia.sections[_selectedSection] as JeopardySection
            ),
            BowlSection => BowlPresenter(
              section: widget.trivia.sections[_selectedSection] as BowlSection,
            ),
            FinalSection => FinalQuestionPresenter(
              section: widget.trivia.sections[_selectedSection] as FinalSection, 
              controller: _finalController
            ),
            MultiAnswerSection => MultiAnswerPresenter(
              section: widget.trivia.sections[_selectedSection] as MultiAnswerSection,
              controller: _multiController
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

      // Jeopardy Section Calls
      case 'jeopardyShowQuestion': {
        _jeopardyController.showQuestion(arguments['category'], arguments['question']);
      }
      case 'jeopardyShowBoard': {
        _jeopardyController.showBoard();
      }
      case 'jeopardyDailyDouble': {
        await _shortAudio.setSource(AssetSource('daily-double.mp3'));
        await _shortAudio.resume();
        _jeopardyController.showDailyDouble();
      }

      // Final Question Section Calls
      case 'finalShowCategory': {
        await _shortAudio.setSource(AssetSource('reveal.mp3'));
        _shortAudio.resume();
        _finalController.showNext();
      }
      case 'finalShowQuestion': {
        await _shortAudio.setSource(AssetSource('reveal.mp3'));
        _shortAudio.resume();
        _finalController.showNext();
      }

      // Multi Answer Calls
      case 'multiShowQuestion': {
        await _shortAudio.setSource(AssetSource('reveal.mp3'));
        _shortAudio.resume();
        _multiController.showQuestion(arguments);
      }
      case 'multiShowAnswer': {
        _multiController.showAnswer(arguments);
      }
      case 'multiScoreAwarded': {
        _multiController.scoreAwarded();
      }
    }
  }
}