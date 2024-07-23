import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/section/final_section.dart';

class FinalQuestionAnswer extends StatefulWidget {
  const FinalQuestionAnswer({
    required this.section,
    required this.showCategory,
    required this.showQuestion,
    required this.updateScore,
    required this.players,
    super.key
  });

  final FinalSection section;
  final Function() showCategory;
  final Function() showQuestion;
  final Function(int, int) updateScore;
  final List<Player> players;

  @override
  State<FinalQuestionAnswer> createState() => _FinalQuestionAnswerState();
}

class _FinalQuestionAnswerState extends State<FinalQuestionAnswer> {
  bool categoryRevealed = false;
  bool questionRevealed = false;
  late List<int> wagers;
  @override
  void initState() {
    wagers = widget.players.map((e) => 0).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(wagers.length < widget.players.length) {
      while(wagers.length < widget.players.length) {
        wagers.add(0);
      }
    }
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
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
          ),
          Expanded(child: Text(widget.section.name, style: Theme.of(context).textTheme.titleMedium)),
          Expanded(child: Text(widget.section.question.question, style: Theme.of(context).textTheme.titleMedium,)),
          Expanded(child: Text(BaseEncoder.decode(widget.section.question.answer), style: Theme.of(context).textTheme.titleLarge,)),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.players.asMap().entries.map((e) {
                TextEditingController controller = TextEditingController()
                  ..text = '${wagers[e.key]}';
                return Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(e.value.name, style: Theme.of(context).textTheme.labelLarge,),
                        Text('Wager (Max ${e.value.score}):', style: Theme.of(context).textTheme.labelMedium),
                        SizedBox(
                          width: constraints.maxWidth * 0.7,
                          child: TextField(
                            controller: controller,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if(value == '') {
                                controller.text = '0';
                                wagers[e.key] = 0;
                                return;
                              }
                              int val = int.parse(value);
                              if(val < 0) {
                                controller.text = '0';
                                wagers[e.key] = 0;
                              }
                              else if(val > e.value.score) {
                                controller.text = '${e.value.score}';
                                wagers[e.key] = e.value.score;
                              }
                              else {
                                wagers[e.key] = val;
                              }
                            },
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.updateScore(e.key, e.value.score + int.parse(controller.text));
                                },
                                icon: const Icon(Icons.thumb_up)
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.updateScore(e.key, e.value.score - int.parse(controller.text));
                                },
                                icon: const Icon(Icons.thumb_down)
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}