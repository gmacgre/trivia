import 'package:flutter/material.dart';
import 'package:trivia/model/section/bowl_section.dart';

class BowlPresenter extends StatefulWidget {
  const BowlPresenter({
    required this.section,
    super.key
  });

  final BowlSection section;

  @override
  State<BowlPresenter> createState() => _BowlPresenterState();
}

class _BowlPresenterState extends State<BowlPresenter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
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
    );
  }
}