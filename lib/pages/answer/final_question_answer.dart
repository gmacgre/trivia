import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/section/final_section.dart';

class FinalQuestionAnswer extends StatefulWidget {
  const FinalQuestionAnswer({
    required this.section,
    required this.showCategory,
    required this.showQuestion,
    required this.updateScore,
    super.key
  });

  final FinalSection section;
  final Function() showCategory;
  final Function() showQuestion;
  final Function(int, int) updateScore;

  @override
  State<FinalQuestionAnswer> createState() => _FinalQuestionAnswerState();
}

class _FinalQuestionAnswerState extends State<FinalQuestionAnswer> {
  bool categoryRevealed = false;
  bool questionRevealed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (categoryRevealed) ? null : () {
                  setState(() {
                    categoryRevealed = true;
                  });
                  widget.showCategory();
                }, 
                child: const Text('Reveal Category')
              ),
              ElevatedButton(
                onPressed: (!categoryRevealed || questionRevealed) ? null : () {
                  setState(() {
                    questionRevealed = true;
                    categoryRevealed = true;
                  });
                  widget.showQuestion();
                }, 
                child: const Text('Reveal Question')
              ),
            ],
          ),
          Text(widget.section.question.question, style: Theme.of(context).textTheme.titleLarge,),
          Text(BaseEncoder.decode(widget.section.question.answer), style: Theme.of(context).textTheme.titleMedium,),
          // TODO: Player Bets
        ],
      ),
    );
  }
}