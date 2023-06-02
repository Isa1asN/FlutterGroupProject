class Progress {
  String userId;
  int alphabet;
  int sound;
  int word;
  int sentence;
  int paragraph;
  Progress({
    required this.userId,
    required this.alphabet,
    required this.sound,
    required this.word,
    required this.sentence,
    required this.paragraph,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'alphabet': alphabet,
      'sound': sound,
      'word': word,
      'sentence': sentence,
      'paragraph': paragraph,
    };
  }

  List<int> toList() {
    return [alphabet, sound, word, sentence, paragraph];
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      userId: map['userId'],
      alphabet: map['alphabet'],
      sound: map['sound'],
      word: map['word'],
      sentence: map['sentence'],
      paragraph: map['paragraph'],
    );
  }
}
