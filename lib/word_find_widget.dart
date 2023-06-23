import 'package:flutter/material.dart';
import 'package:word_find_puzzle/word_find_model.dart';
import 'package:word_search_safety/word_search_safety.dart';

class WordFindWidget extends StatefulWidget {
  const WordFindWidget({super.key, required this.listQues, required this.size});
  final List<WordFindQues> listQues;
  final Size size;

  @override
  State<WordFindWidget> createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  int indexQue = 0;
  List<WordFindQues>? listQues;
  @override
  void initState() {
    super.initState();
    listQues = widget.listQues;
    generatePuzzle();
  }

  generatePuzzle({
    List<WordFindQues>? loop,
    bool next = false,
    bool left = false,
  }) {
    if (loop != null) {
      indexQue = 0;
      listQues!.addAll(loop);
    } else {
      if (next && indexQue < widget.listQues.length - 1) {
        indexQue++;
      } else if (left && indexQue > 0) {
        indexQue--;
      } else if (indexQue >= listQues!.length - 1) {
        return;
      }
      setState(() {});
      if (listQues![indexQue].isDone) return;
    }

    WordFindQues currentQues = listQues![indexQue];
    setState(() {});
    final List<String> wl = [currentQues.answer];
    final WSSettings ws = WSSettings(
      width: 16,
      height: 1,
      orientations: List.from([WSOrientation.horizontal]),
    );

    final WordSearchSafety wordSearch = WordSearchSafety();

    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

    if (newPuzzle.errors!.isEmpty) {
      currentQues.arrayBttns =
          newPuzzle.puzzle!.expand((list) => list).toList();
      currentQues.arrayBttns!.shuffle();

      bool isDone = currentQues.isDone;

      if (!isDone) {
        currentQues.puzzles = List.generate(wl[0].split("").length, (index) {
          return WordFindChar(
              correctValue: currentQues.answer.split("")[index]);
        });
      } else {}
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WordFindQues currentQues = listQues![indexQue];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: currentQues.puzzles!.map((puzzle) {
                  Color color = Colors.white;

                  if (currentQues.isDone) {
                    color = Colors.greenAccent;
                  } else if (currentQues.isFull) {
                    color = Colors.redAccent;
                  } else {
                    color = Colors.white;
                  }

                  return InkWell(
                    onTap: () {
                      if (currentQues.isDone) return;
                      currentQues.isFull = false;
                      puzzle.clearValue();
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: constraints.biggest.width / 7 - 6,
                      height: constraints.biggest.width / 7 - 6,
                      margin: const EdgeInsets.all(3),
                      child: Text((puzzle.currentValue ?? "").toUpperCase()),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Text(currentQues.question),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 16,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              bool statusBttn = currentQues.puzzles!
                      .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                  0;

              return LayoutBuilder(
                builder: (context, constraints) {
                  return ElevatedButton(
                    onPressed: !statusBttn
                        ? () {
                            setBttnClick(index);
                          }
                        : null,
                    child: Text(
                      currentQues.arrayBttns![index].toUpperCase(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  setBttnClick(int index) async {
    WordFindQues currentQues = listQues![indexQue];

    int currentIndexEmpty = currentQues.puzzles!
        .indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles![currentIndexEmpty].currentIndex = index;
      currentQues.puzzles![currentIndexEmpty].currentValue =
          currentQues.arrayBttns![index];

      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(const Duration(seconds: 1));

        generatePuzzle(next: true);
      }
      setState(() {});
    }
  }
}
