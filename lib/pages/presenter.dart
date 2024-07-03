import 'package:flutter/material.dart';
import 'package:trivia/model/trivia.dart';

class PresenterPage extends StatefulWidget {
  const PresenterPage({
    required this.trivia,
    super.key
  });

  final Trivia trivia;

  @override
  State<PresenterPage> createState() => _PresenterPageState();
}

class _PresenterPageState extends State<PresenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('asdfasdf'),
      ),
      body: const Placeholder(),
    );
  }
}