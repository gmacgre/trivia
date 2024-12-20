import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/bowl_section.dart';
import 'package:trivia/model/section/final_section.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/multianswer_section.dart';
import 'package:trivia/model/section/section.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/pages/answer/bowl_answer.dart';
import 'package:trivia/pages/answer/final_question_answer.dart';
import 'package:trivia/pages/answer/jeopardy_answer.dart';
import 'package:trivia/pages/answer/multi_answer.dart';
import 'package:trivia/pages/answer/section_selection.dart';

class AnswersPage extends StatefulWidget {
  final String trivia;
  const AnswersPage({
    super.key,
    required this.trivia
  });

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  Trivia _trivia = Trivia(title: 'DebugTitle', sections: []);
  int _currentSection = -1;
  final List<Player> _players = [];
  
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    backgroundColor: Colors.blue, // <-- Button color
    foregroundColor: Colors.white, // <-- Splash color
  );
  
  @override
  void initState() {
    _trivia = FileManager.decode(widget.trivia);
    super.initState();
  }

  // Builds a Player Adder and Section Selector, and any subchild if needed.
  @override
  Widget build(BuildContext context) {
    // Player Adder
    List<Widget> base = [];
    base.addAll(_players.asMap().entries.map((e) {
      TextEditingController nameController = TextEditingController(
        text: e.value.name
      );
      TextEditingController scoreController = TextEditingController(
        text: '${e.value.score}'
      );
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if(!hasFocus) {
                            setState(() {
                              _players[e.key].name = nameController.text;
                            });
                            DesktopMultiWindow.invokeMethod(0, 'setName', {
                              'name': nameController.text,
                              'index': e.key
                            });
                          }
                        },
                        child: TextField(controller: nameController, textAlign: TextAlign.center,),
                      ),
                    ),
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            var parsed = int.tryParse(scoreController.text);
                            _updateScore(e.key, (parsed != null) ? int.parse(scoreController.text) : 0);
                          }
                        },
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0123456789\-]'))
                          ],
                          controller: scoreController,
                          textAlign: TextAlign.center,              
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _players.removeAt(e.key);
                  });
                  DesktopMultiWindow.invokeMethod(0, 'deletePlayer', e.key);
                }, icon: const Icon(Icons.remove)
              )
            ],
          ),
        ),
      );
    }));

    base.add(
      ElevatedButton(
        onPressed: () {
          setState(() {
            _players.add(Player(score: 0, name: 'New'));  
          });
          DesktopMultiWindow.invokeMethod(0, 'newPlayer', {
            'name': 'New',
            'score': 0
          });
        }, 
        style: buttonStyle,
        child: const Icon(Icons.add)
      )
    );
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: _getMainSection()
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: base
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  [
                    'buzz',
                    Icons.access_alarm,
                    () {}
                  ],
                  [
                    'theme',
                    Icons.music_note,
                    () {}
                  ],
                  [
                    'sections',
                    Icons.tv,
                    () {
                      setState(() {
                        _currentSection = -1;
                      });
                    }
                  ],
                  [
                    'pop',
                    Icons.flag,
                    () {}
                  ],
                ].map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        DesktopMultiWindow.invokeMethod(0, e[0] as String);
                        (e[2] as Function())();
                      },
                      icon: Icon(e[1] as IconData, color: Colors.white70,)
                    ),
                  ),
                ).toList(),
              ),
            )
          ],
        ),
      )
    );
  }

  void _updateScore(int idx, int newScore) {
    setState(() {
      _players[idx].score = newScore;
    });
    DesktopMultiWindow.invokeMethod(0, 'setScore', {
      'index': idx,
      'score': newScore
    });
  }

  Widget _getMainSection() {
    if(_currentSection == -1) {
      return SectionSelection(
        sections: _trivia.sections,
        launcher: (idx) {
          DesktopMultiWindow.invokeMethod(0, 'launchSection', idx);
          setState(() {
            _currentSection = idx;
          });
        },
      );
    }
    else {
      Section selected = _trivia.sections[_currentSection];
      return switch(selected.runtimeType) {
        JeopardySection => JeopardyAnswer(
          section: selected as JeopardySection,
          players: _players,
          scoreUpdater: _updateScore,
          showBoard: () {
            DesktopMultiWindow.invokeMethod(0, 'jeopardyShowBoard');
          },
          showQuestion: (catIdx, qIdx) {
            DesktopMultiWindow.invokeMethod(0, 'jeopardyShowQuestion', {
              'category': catIdx,
              'question': qIdx
            });
          },
          showDailyDouble: () {
            DesktopMultiWindow.invokeMethod(0, 'jeopardyDailyDouble');
          },
        ),
        BowlSection => BowlAnswer(
          players: _players,
          section: selected as BowlSection,
          updateScore: _updateScore,
          showQuestion: (idx) {

          },
        ),
        FinalSection => FinalQuestionAnswer(
          section: selected as FinalSection,
          showCategory: () {
            DesktopMultiWindow.invokeMethod(0, 'finalShowCategory');
          },
          showQuestion: () {
            DesktopMultiWindow.invokeMethod(0, 'finalShowQuestion');
          },
          updateScore: _updateScore,
          players: _players,
        ),
        MultiAnswerSection => MultiAnswer(
          section: selected as MultiAnswerSection,
          players: _players,
          showQuestion: (idx) {
            DesktopMultiWindow.invokeMethod(0, 'multiShowQuestion', idx);
          },
          showAnswer: (idx) {
            DesktopMultiWindow.invokeMethod(0, 'multiShowAnswer', idx);
          },
          awardPoints: (player, points) {
            _updateScore(player, _players[player].score + points);
            DesktopMultiWindow.invokeMethod(0, 'multiScoreAwarded');
          },
        ),
        _ => const Placeholder()
      };
    }
  }
}
