class Word {
  final int? id;
  final String name;

  Word({this.id, required this.name});

  factory Word.fromMap(Map<String, dynamic> json) => Word(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
