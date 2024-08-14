import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/model/section/bowl_section.dart';

class BowlAnswer extends StatefulWidget {
  const BowlAnswer({
    required this.players, 
    required this.section,
    required this.updateScore,
    required this.showQuestion,
    super.key
  });

  final List<Player> players;
  final BowlSection section;
  final Function(int, int) updateScore;
  final Function(int) showQuestion;

  @override
  State<BowlAnswer> createState() => _BowlAnswerState();
}

class _BowlAnswerState extends State<BowlAnswer> {
  late List<Question> toShow;
  Question? currentQuestion;

  Random random = Random();

  @override
  void initState() {
    toShow = widget.section.questions.map((e) => Question(question: e.question, answer: e.answer, imageLink: e.imageLink)).toList();
    _setQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text((currentQuestion != null) ? currentQuestion!.question : 'No Question.', style: Theme.of(context).textTheme.displaySmall,),
        Text((currentQuestion != null) ? BaseEncoder.decode(currentQuestion!.answer) : 'No Question.', style: Theme.of(context).textTheme.headlineLarge,),
        Wrap(
          children: widget.players.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: (currentQuestion != null) ? () {
                widget.updateScore(e.key, e.value.score + widget.section.value);
                setState(() {
                  _setQuestion();
                });
              } : null, 
              child: Text(e.value.name)
            ),
          )).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _setQuestion();
            });
          }, 
          child: const Text('No Points')
        )
      ],
    );
  }

  void _setQuestion() {
    if(toShow.isEmpty) {
      currentQuestion = null;
      return;
    }
    int toUse = random.nextInt(toShow.length);
    currentQuestion = toShow[toUse];
    toShow.removeAt(toUse);
  }
}
