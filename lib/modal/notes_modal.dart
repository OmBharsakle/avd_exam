class NotesModal {
  late int id;
  late String title, content, category, date;

  NotesModal({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });

  factory NotesModal.fromMap(Map m1) {
    return NotesModal(
      id: m1['id'],
      title: m1['title'],
      content: m1['content'],
      category: m1['category'],
      date: m1['date'],
    );
  }
}

Map toMap(NotesModal notes) {
  return {
    'id': notes.id,
    'title': notes.title,
    'content': notes.content,
    'category': notes.category,
    'date': notes.date,
  };
}
