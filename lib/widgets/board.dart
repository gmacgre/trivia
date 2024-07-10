import 'package:flutter/material.dart';
import 'package:trivia/model/trivia.dart';

class QuestionBoard extends StatelessWidget {
  const QuestionBoard({
    required this.selected,
    required this.trivia,
    this.listener,
    super.key
  });

  final List<List<bool>> selected;
  final Trivia trivia;
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
    for(final (index, category) in trivia.categories.indexed) {
      // Add the Category Title Card
      grid.add(
        Container(
          decoration: categoryDecoration,
          child: Center(
            child: Text(
              category.title,
              style: const TextStyle(color: Colors.white),
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
            child: Center(child: (!selected[index][e.key]) ? Text('${e.key}') : null),
          ),
        )
      ).toList());
    }
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      crossAxisCount: (trivia.categories[0].questions.length + 1),
      children: grid,
    );
  }
}

abstract class QuestionBoardListener {
  void processTap(int category, int question);
}