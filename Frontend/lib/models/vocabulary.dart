class Vocabulary {
  late String word;
  int? id;
  late String category;
  late String meaning;
  late String description;
  int? localId;
  String? createdBy;

  Vocabulary({
    required this.id,
    required this.word,
    required this.category,
    required this.meaning,
    required this.description,
  });

  Vocabulary.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'] ?? json["localId"];
    word = json['word'] ?? "";
    category = json['category'] ?? "";
    meaning = json['meaning'] ?? "";
    description = json['description'] ?? "";
    localId = json["id"] ?? json["localId"];
    createdBy = json["createdById"] ?? "";
  }
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'category': category,
      'meaning': meaning,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Vocabulary{id: $id, word: $word, category: $category, meaning: $meaning, description: $description}';
  }

  Map<String, dynamic> toJson() => {
        'localId': localId,
        'word': word,
        'category': category,
        'meaning': meaning,
        'description': description,
      };
}
