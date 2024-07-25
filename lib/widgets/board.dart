import 'package:flutter/material.dart';
import 'package:trivia/model/section/jeopardy_section.dart';

class JeopardyQuestionBoard extends StatelessWidget {
  const JeopardyQuestionBoard({
    required this.selected,
    required this.section,
    required this.value,
    this.listener,
    this.dailyDoubles,
    super.key
  });

  final List<List<bool>> selected;
  final JeopardySection section;
  final QuestionBoardListener? listener;
  final int value;
  final Set<List<int>>? dailyDoubles;

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

    BoxDecoration doubleDecoration = BoxDecoration(
      color: Colors.red[300],
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
              style: TextStyle(color: Colors.white, fontSize: (listener == null)? 25 : 10),
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
            decoration: (dailyDoubles != null && _isDailyDouble(index, e.key)) ? doubleDecoration : questionDecoration,
            child: Center(child: (!selected[index][e.key]) ? Text('${((e.key + 1) * value)}', style: (listener == null) ? Theme.of(context).textTheme.headlineLarge:Theme.of(context).textTheme.labelLarge ) : null),
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

  bool _isDailyDouble(int x, int y) {
    var check  = dailyDoubles!.toList();
    for(var pair in check) {
      if(pair[0] == x && pair[1] == y) {
        return true;
      }
    }
    return false;
  }
}

abstract class QuestionBoardListener {
  void processTap(int category, int question);
}