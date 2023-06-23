import 'package:flutter/material.dart';
import 'package:word_find_puzzle/word_find_model.dart';
import 'package:word_find_puzzle/word_find_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WordFindQues>? _wordFindQues;

  @override
  void initState() {
    _wordFindQues = [
      WordFindQues(
        answer: "Cat",
        question: "Which Animal",
      ),
      WordFindQues(
        answer: "Ajay Pangare",
        question: "Who is he",
      ),
      WordFindQues(
        answer: "Reno",
        question: "Which Animal",
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    color: Colors.blue,
                    child: WordFindWidget(
                      size: constraints.biggest,
                      listQues: _wordFindQues!,
                    ),
                  );
                },
              )),
              ElevatedButton(
                child: const Text("Reload"),
                onPressed: () {
                  // call generatePuzzle from widget
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
