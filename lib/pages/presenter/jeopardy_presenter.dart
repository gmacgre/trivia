import 'package:flutter/material.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/widgets/board.dart';

class JeopardyPresenterController {
  late void Function(int, int) showQuestion;
  late void Function() showBoard;
}

class JeopardyPresenter extends StatefulWidget {
  const JeopardyPresenter({
    required this.section,
    required this.controller,
    super.key
  });

  final JeopardySection section;
  final JeopardyPresenterController controller;

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

    // Controller Commands
    widget.controller.showQuestion = (catIdx, qIdx) {
      setState(() {
        _selectedCategory = catIdx;
        _selectedQuestion = qIdx;
      });
    };
    widget.controller.showBoard = () {
      setState(() {
        _previouslySelected[_selectedCategory][_selectedQuestion] = true;
        _selectedCategory = -1;
        _selectedQuestion = -1;
      });
    };
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

  void showQuestion(int catIdx, int qIdx) {
    setState(() {
      _selectedCategory = catIdx;
      _selectedQuestion = qIdx;
    });
  }

  void showBoard() {
    setState(() {
      _selectedCategory = -1;
      _selectedQuestion = -1;
    });
  }
}