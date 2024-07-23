import 'package:flutter/material.dart';
import 'package:trivia/model/section/final_section.dart';

class FinalQuestionPresenter extends StatefulWidget {
  const FinalQuestionPresenter({
    required this.section,
    required this.controller,
    super.key
  });


  final FinalSection section;
  final FinalQuestionPresenterController controller;

  @override
  State<FinalQuestionPresenter> createState() => _FinalQuestionPresenterState();
}

class _FinalQuestionPresenterState extends State<FinalQuestionPresenter> {
  _DisplayState state = _DisplayState.preview;

  @override
  void initState() {
    widget.controller.showNext = () {
      setState(() {
        state = switch (state) {
          _DisplayState.preview => _DisplayState.category,
          _DisplayState.category => _DisplayState.question,
          _DisplayState.question => _DisplayState.error,
          _DisplayState.error => _DisplayState.error
        };
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch (state) {
        _DisplayState.preview => Stack(
          children: [
            Icon(
              Icons.lightbulb,
              size: MediaQuery.of(context).size.height / 2,
              color: Theme.of(context).primaryColorLight,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.section.title, style: Theme.of(context).textTheme.headlineMedium,)
              )
            )
          ],
        ),
        _DisplayState.category => SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            widget.section.name,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        _DisplayState.question => SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            widget.section.question.question, 
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        _DisplayState.error => const Icon(Icons.error),
      },
    );
  }
}

enum _DisplayState {
  preview,
  category,
  question,
  error
}

class FinalQuestionPresenterController {
  late void Function() showNext;
}