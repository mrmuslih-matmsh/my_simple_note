class Note {
  int? id;
  String title;
  String content;
  DateTime modifiedTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'modifiedTime': modifiedTime.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      modifiedTime: DateTime.parse(map['modifiedTime']),
    );
  }
}
