import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  const Selector({
    required this.contents,
    required this.onSelection,
    required this.selected,
    super.key
  });

  final List<String> contents; 
  final Function(int) onSelection;
  final int selected;

  @override
  Widget build(BuildContext context) {
    List<Widget> categories = contents.asMap().entries.map((e) => ListTile(
      title: Text(e.value),
      selected: selected == e.key,
      onTap: () => { onSelection(e.key) },
    )).toList();
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).disabledColor, width: 5.0)),
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: categories,
      )
    );
  }
}