class Note {
  final String id;
  final String text;

  Note({
    required this.id,
    required this.text,
  });

  factory Note.fromDoc(dynamic doc) {
    return Note(
      id: doc.id,
      text: doc['text'] ?? '',
    );
  }
}
