class WordofDay {
  String? id;
  late String word;
  late String category;
  late String meaning;
  late String example;
  int? localId;
  String? createdBy;

  WordofDay({
    required this.id,
    required this.word,
    required this.category,
    required this.meaning,
    required this.example,
  });

  WordofDay.fromJson(Map<String, dynamic> json) {
    print("---------------------------------$json");
    id = json["id"].toString();
    word = json['word'] ?? "";
    category = json["category"] ?? "";
    meaning = json['meaning'] ?? "";
    example = json['example'] ?? "";
    localId = json["localId"] ?? 100000;
    createdBy = json["createdBy"] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      "word": word,
      "category": category,
      "meaning": meaning,
      "example": example,
    };
  }

  // @override
  // String toString() {
  //   return 'WordofDay{id:$id, word: $word, meaning: $meaning, example: $example}';
  // }
}
