class WordFindQues {
  String question;
  String? imgPath;
  String answer;
  bool isDone;
  bool isFull;
  List<WordFindChar>? puzzles;
  List<String>? arrayBttns;

  WordFindQues({
    required this.question,
    this.imgPath,
    required this.answer,
    this.isDone = false,
    this.isFull = false,
    this.puzzles,
    this.arrayBttns,
  });

  void setWordFindChar(List<WordFindChar> puzzle) => puzzles = puzzle;

  void setIsDone() => isDone = true;

  bool fieldCompleteCorrect() {
    bool complete =
        puzzles!.where((puzzle) => puzzle.currentValue == null).isEmpty;
    if (!complete) {
      isFull = false;
      return complete;
    }
    isFull = true;

    String answeredString =
        puzzles!.map((puzzle) => puzzle.currentValue).join();
    // if ans corret
    return answeredString == answer;
  }

  WordFindQues clone() {
    return WordFindQues(
      answer: answer,
      imgPath: imgPath,
      question: question,
    );
  }
}

class WordFindChar {
  String? currentValue;
  int? currentIndex;
  String? correctValue;
  bool hintShow;

  WordFindChar({
    this.currentValue,
    this.currentIndex,
    this.correctValue,
    this.hintShow = false,
  });

  getCurrentValue() {
    if (correctValue != null) {
      return currentValue;
    } else if (hintShow) {
      return correctValue;
    }
  }

  void clearValue() {
    currentIndex = null;
    currentValue = null;
  }
}
