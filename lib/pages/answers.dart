import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/widgets/board.dart';

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
  Trivia _trivia = Trivia(title: 'DebugTitle');
  final List<List<bool>> _previouslySelected = [];
  final List<Player> _players = [];
  late final QuestionBoardListener _listener;
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    backgroundColor: Colors.blue, // <-- Button color
    foregroundColor: Colors.white, // <-- Splash color
  );
  int _selectedCategory = -1;
  int _selectedQuestion = -1;
  
  


  @override
  void initState() {
    _trivia = FileManager.decode(widget.trivia);
    for(Category category in _trivia.categories) {
      List<bool> sets = [];
      for(int i = 0; i < category.questions.length; i++) {
        sets.add(false);
      }
      _previouslySelected.add(sets);
    }
    _listener = _AnswerQuestionBoardListener(parent: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _trivia.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Expanded(
            child: (_selectedCategory == -1 && _selectedQuestion == -1) ? _getBoardAndScores() : _getQuestionView()
          ),
        ],
      )
    );
  }

  Widget _getBoardAndScores() {
    List<Widget> base = [];
    
    base.addAll(_players.asMap().entries.map((e) {
      TextEditingController nameController = TextEditingController(
        text: e.value.name
      );
      TextEditingController scoreController = TextEditingController(
        text: '${e.value.score}'
      );
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _players[e.key].name = nameController.text;
                    });
                    DesktopMultiWindow.invokeMethod(0, 'setName', {
                      'name': nameController.text,
                      'index': e.key
                    });
                  },
                  style: buttonStyle,
                  child: const Icon(Icons.check)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: scoreController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _players[e.key].score = int.parse(scoreController.text);
                    });
                    _updateScore(e.key, int.parse(scoreController.text));
                  },
                  style: buttonStyle,
                  child: const Icon(Icons.check)
                )
              ],
            ),
          ],
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: QuestionBoard(
                selected: _previouslySelected,
                trivia: _trivia,
                listener: _listener,
              )
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: base
            ),
          )
        )
      ],
    );
  }

  Widget _getQuestionView() {
    Question question = _trivia.categories[_selectedCategory].questions[_selectedQuestion];
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              BaseEncoder.decode(question.answer),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _players.asMap().entries.map((e) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _players[e.key].score += (_selectedQuestion + 1) * 100;
                      _updateScore(e.key, _players[e.key].score);
                      _returnToBoard();
                    },
                    child: Text('${e.value.name} Correct')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _players[e.key].score -= (_selectedQuestion + 1) * 100;
                      _updateScore(e.key, _players[e.key].score);
                    },
                    child: Text('${e.value.name} Incorrect')
                  ),
                ],
              )).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                DesktopMultiWindow.invokeMethod(0, 'buzz');
              },
              child: const Text('Buzzer')
            ),        
            ElevatedButton(
              onPressed: _returnToBoard,
              child: const Text('Return to Board')
            )
          ],
        ),
      ),
    );
  }

  void _updateScore(int idx, int score) {
    DesktopMultiWindow.invokeMethod(0, 'setScore', {
      'score': score,
      'index': idx
    });
  }

  void _returnToBoard() {
    setState(() {
      _previouslySelected[_selectedCategory][_selectedQuestion] = true;
      _selectedCategory = -1;
      _selectedQuestion = -1;
    });
    DesktopMultiWindow.invokeMethod(0, 'board');
  }

  void _setSelection(int category, int question) {
    setState(() {
      _selectedCategory = category;
      _selectedQuestion = question;
    });
    DesktopMultiWindow.invokeMethod(0, 'selection', {
      'category': category,
      'question': question
    });
  }
}

class _AnswerQuestionBoardListener implements QuestionBoardListener {
  final _AnswersPageState parent;
  const _AnswerQuestionBoardListener({
    required this.parent
  });

  @override
  void processTap(int category, int question) {
    parent._setSelection(category, question);
  }
}