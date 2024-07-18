import 'package:flutter/material.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/widgets/board.dart';

class JeopardyPresenter extends StatefulWidget {
  const JeopardyPresenter({
    required this.players,
    required this.section,
    super.key
  });

  final JeopardySection section;
  final List<Player> players;

  @override
  State<JeopardyPresenter> createState() => _JeopardyPresenterState();
}

class _JeopardyPresenterState extends State<JeopardyPresenter> {

  int _selectedCategory = -1;
  int _selectedQuestion = -1;
  final List<List<bool>> _previouslySelected = [];

  @override
  void initState() {
    // BUILDING SELECTED BOARD
    for(Category category in widget.section.categories) {
      List<bool> sets = [];
      for(int i = 0; i < category.questions.length; i++) {
        sets.add(false);
      }
      _previouslySelected.add(sets);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool showQuestion = _selectedCategory != -1 && _selectedQuestion != -1;
    return Center(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: JeopardyQuestionBoard(
                      selected: _previouslySelected,
                      section: widget.section,
                    )
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.players.map((e) => Column(
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
                  )).toList(),
                ),
              )
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: (showQuestion) ?  7.0 : 0.0
                  )
                ),
                duration: (showQuestion) ? const Duration(milliseconds: 500) : const Duration(milliseconds: 0),
                width: (showQuestion) ? MediaQuery.of(context).size.width : 0.0,
                height: (showQuestion) ? MediaQuery.of(context).size.height : 0.0,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {

                      // Image Question
                      if(showQuestion &&
                          widget.section.categories[_selectedCategory].questions[_selectedQuestion].imageLink != '') {
                        return Image.network(widget.section.categories[_selectedCategory].questions[_selectedQuestion].imageLink);
                      }

                      // Default Question, Just Show Question Text
                      return SizedBox(
                        width: constraints.maxWidth * 0.6,
                        child: AnimatedDefaultTextStyle(
                          duration: (showQuestion) ? const Duration(milliseconds: 500) : const Duration(milliseconds: 0),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: (showQuestion) ? 40.0 : 0.0
                          ),
                          child: Text(
                            (showQuestion) ? 
                              widget.section.categories[_selectedCategory].questions[_selectedQuestion].question : '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}