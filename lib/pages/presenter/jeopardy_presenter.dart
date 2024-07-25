import 'package:flutter/material.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/widgets/board.dart';

class JeopardyPresenterController {
  late void Function(int, int) showQuestion;
  late void Function() showBoard;
  late void Function() showDailyDouble;
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
  bool _showDouble = false;
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
        _showDouble = false;
      });
    };
    widget.controller.showBoard = () {
      setState(() {
        _previouslySelected[_selectedCategory][_selectedQuestion] = true;
        _selectedCategory = -1;
        _selectedQuestion = -1;
      });
    };
    widget.controller.showDailyDouble = () {
      setState(() {
        _showDouble = true;
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
              Text(widget.section.title, style: Theme.of(context).textTheme.displaySmall,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: JeopardyQuestionBoard(
                      value: widget.section.value,
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
                    width: (showQuestion || _showDouble) ?  7.0 : 0.0
                  )
                ),
                duration: (showQuestion || _showDouble) ? const Duration(milliseconds: 500) : const Duration(milliseconds: 0),
                width: (showQuestion || _showDouble) ? MediaQuery.of(context).size.width : 0.0,
                height: (showQuestion || _showDouble) ? MediaQuery.of(context).size.height : 0.0,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {

                      // Image Question
                      if(showQuestion &&
                          widget.section.categories[_selectedCategory].questions[_selectedQuestion].imageLink != '') {
                        return Image.network(widget.section.categories[_selectedCategory].questions[_selectedQuestion].imageLink);
                      }
                      if(_showDouble) {
                        return Image.network('https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d441cefe-a967-4209-918d-d3d09831b3e7/dfe9347-44cb29b6-c747-44e6-8ae5-d77f411785c9.png/v1/fit/w_828,h_460,q_70,strp/jeopardy__season_33_daily_double_logo_by_onscreenthatprods_dfe9347-414w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NTI3IiwicGF0aCI6IlwvZlwvZDQ0MWNlZmUtYTk2Ny00MjA5LTkxOGQtZDNkMDk4MzFiM2U3XC9kZmU5MzQ3LTQ0Y2IyOWI2LWM3NDctNDRlNi04YWU1LWQ3N2Y0MTE3ODVjOS5wbmciLCJ3aWR0aCI6Ijw9OTQ5In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.yrGQQB6ciBX5I7FlE_qmS9_WTkSsAf3m-mF3Q9uZss4');
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