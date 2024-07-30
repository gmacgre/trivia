import 'package:flutter/material.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/multianswer_section.dart';
import 'package:trivia/widgets/selector.dart';

class MultiAnswer extends StatefulWidget {
  const MultiAnswer({
    super.key,
    required this.section,
    required this.players,
    required this.showQuestion,
    required this.showAnswer,
    required this.awardPoints,
  });

  final MultiAnswerSection section;
  final List<Player> players;
  final Function(int) showQuestion;
  final Function(int) showAnswer;
  final Function(int, int) awardPoints;

  @override
  State<MultiAnswer> createState() => _MultiAnswerState();
}

class _MultiAnswerState extends State<MultiAnswer> {

  int selected = -1;
  List<bool> seen = [];
  int totalPoints = -1;
  bool awarded = false;

  @override
  Widget build(BuildContext context) {
    // Build Two Columns- one for the questions and one for the answers window
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Selector(
                  contents: widget.section.questions.map((e) => e.question).toList(),
                  onSelection: (value) {
                    widget.showQuestion(value);
                    setState(() {
                      selected = value;
                      seen = widget.section.questions[selected].answers.map((e) => false).toList();
                      totalPoints = 0;
                      awarded = false;
                    });
                  },
                  selected: selected
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).disabledColor, width: 3)),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total Points Scored: $totalPoints',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.players.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(e.value.name),
                                IconButton(
                                  onPressed: (awarded) ? null : () {
                                    widget.awardPoints(e.key, totalPoints);
                                    setState(() {
                                      awarded = true;
                                    });
                                  }, 
                                  icon: const Icon(Icons.add)
                                )
                              ],
                            ),
                          )).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ),
        Expanded(
          flex: 3,
          child: (selected != -1) ? GridView.count(
            crossAxisCount: 5,
            scrollDirection: Axis.vertical,
            children: widget.section.questions[selected].answers.asMap().entries.map((e) => InkWell(
              onTap: (seen[e.key] == true) ? null : () {
                widget.showAnswer(e.key);
                setState(() {
                  seen[e.key] = true;
                  if(!awarded) totalPoints += widget.section.questions[selected].value;
                });
              },
              child: Ink(
                decoration: BoxDecoration(border: Border.all(color: (seen[e.key]) ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight, width: 3)),
                child: Center(
                  child: Text(
                    '${e.key + 1}: ${e.value}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )).toList(), 
          ) :
          Center(
            child: Text(
              'Select Question to Start',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        )
      ],
    );
  }
}