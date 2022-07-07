const String tableNotes = 'notes';

// define all columns in the table from NoteModel
// note fields in the database
class NoteFields {
  static const String id = '_id';
  static const String number = 'number';
  static const String isImportnant = 'isImportnant';
  static const String title = 'title';
  static const String description = 'description';
  static const String date = 'date';
}

class NoteModel {
  // note model
  int? id;
  final int number;
  final bool isImportnant;
  final String title;
  final String description;
  final DateTime date;

  NoteModel({
    this.id,
    required this.number,
    required this.isImportnant,
    required this.title,
    required this.description,
    required this.date,
  });
  //toMap method
  Map<String, dynamic> toMap() {
    return {
      NoteFields.id: id,
      NoteFields.number: number,
      // convert bool to int
      NoteFields.isImportnant: isImportnant ? 1 : 0,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.date: date.toIso8601String(),
    };
  }

  //fromMap method
  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map[NoteFields.id] as int,
      number: map[NoteFields.number] as int,
      isImportnant: map[NoteFields.isImportnant] == 1,
      title: map[NoteFields.title] as String,
      description: map[NoteFields.description] as String,
      date: DateTime.parse(map[NoteFields.date] as String),
    );
  }
}
