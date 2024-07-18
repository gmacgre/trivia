import 'package:flutter/material.dart';
import 'package:trivia/model/section/jeopardy_section.dart';

class JeopardyQuestionBoard extends StatelessWidget {
  const JeopardyQuestionBoard({
    required this.selected,
    required this.section,
    this.listener,
    super.key
  });

  final List<List<bool>> selected;
  final JeopardySection section;
  final QuestionBoardListener? listener;

  @override
  Widget build(BuildContext context) {
    BoxDecoration categoryDecoration = BoxDecoration(
      color: Theme.of(context).primaryColor,
      border: Border.all(color: Colors.grey)
    );

    BoxDecoration questionDecoration = BoxDecoration(
      color: Theme.of(context).secondaryHeaderColor,
      border: Border.all(color: Colors.grey)
    );

    List<Widget> grid = [];
    for(final (index, category) in section.categories.indexed) {
      // Add the Category Title Card
      grid.add(
        Container(
          decoration: categoryDecoration,
          child: Center(
            child: Text(
              category.title,
              style: TextStyle(color: Colors.white, fontSize: (listener == null)? 25 : 13),
              textAlign: TextAlign.center,
            ),
          ),
        )
      );
      // Add Question Title Cards
      grid.addAll(category.questions.asMap().entries.map((e) => 
        InkWell(
          onTap: (!selected[index][e.key] && listener != null) ? () {
            listener?.processTap(index, e.key);
          } : null,
          child: Ink(
            decoration: questionDecoration,
            child: Center(child: (!selected[index][e.key]) ? Text('${((e.key + 1) * 100)}', style: Theme.of(context).textTheme.headlineLarge,) : null),
          ),
        )
      ).toList());
    }
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      crossAxisCount: (section.categories[0].questions.length + 1),
      children: grid,
    );
  }
}

abstract class QuestionBoardListener {
  void processTap(int category, int question);
}