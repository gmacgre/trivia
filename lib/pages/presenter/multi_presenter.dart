import 'package:flutter/material.dart';
import 'package:trivia/model/section/multianswer_section.dart';

class MultiAnswerPresenterController {
  late void Function() scoreAwarded;
  late void Function(int) showQuestion;
  late void Function(int) showAnswer;
}

class MultiAnswerPresenter extends StatefulWidget {
  const MultiAnswerPresenter({
    super.key,
    required this.section,
    required this.controller,
  });

  final MultiAnswerSection section;
  final MultiAnswerPresenterController controller;

  @override
  State<MultiAnswerPresenter> createState() => _MultiAnswerPresenterState();
}

class _MultiAnswerPresenterState extends State<MultiAnswerPresenter> {
  bool awarded = false;
  List<bool> revealed = [];
  int toShow = -1;
  int scored = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.scoreAwarded = () {
      setState(() {
        awarded = true;
      });
    };
    widget.controller.showQuestion = (idx) {
      if(idx < 0 || idx > widget.section.questions.length) return;
      setState(() {
        toShow = idx;
        revealed = widget.section.questions[toShow].answers.map((e) => false).toList();
        scored = 0;
        awarded = false;
      });
    };
    widget.controller.showAnswer = (idx) {
      if(idx >= revealed.length || idx < 0) return;
      setState(() {
        revealed[idx] = true;
        if(!awarded) scored += widget.section.questions[toShow].value;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if(toShow == -1) {
      return Center(
        child: Icon(
          Icons.lightbulb,
          size: MediaQuery.of(context).size.height * 0.6,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    List<String> answers = widget.section.questions[toShow].answers;
    int offset = (answers.length % 2 == 0) ? answers.length ~/ 2 : (answers.length ~/ 2) + 1;
    List<TableRow> rows = answers.sublist(0, offset).asMap().entries.map((e) => TableRow(
      children: [
        _buildQuestionItem(e.key),
        _buildQuestionItem(e.key + offset)
      ]
    )).toList();

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.lightbulb,
              size: MediaQuery.of(context).size.height * 0.6,
              color: Theme.of(context).primaryColor,
            ),
          )
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(width: 5),
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$scored',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                      )
                    ),
                  ),
                ),
                Table(
                  children: rows,
                ),
              ],
            )
          )
        )
      ]
    );
  }

  Widget _buildQuestionItem(int idx) {
    BoxDecoration decoration = BoxDecoration(
      color: Theme.of(context).primaryColorLight,
      border: Border.all(width: 5),
      borderRadius: BorderRadius.circular(100)
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,1,8.0,1),
      child: Container(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (idx < widget.section.questions[toShow].answers.length) ? 
          (revealed[idx]) ?
            Text(
              widget.section.questions[toShow].answers[idx],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ) :
            Text(
              '${idx + 1}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ) :
          Text(
            '',
            style: Theme.of(context).textTheme.headlineMedium
          )
        )  
      ),
    );
  }
}
