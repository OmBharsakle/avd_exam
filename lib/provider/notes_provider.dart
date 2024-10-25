import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../modal/notes_modal.dart';
import '../services/notes_services.dart';

class NotesProvider extends ChangeNotifier {
  List notesList = [];
  List<NotesModal> notesModal = [];
  List<NotesModal> notesCloudList = [];
  var txtTitle = TextEditingController();
  var txtContent = TextEditingController();
  var txtCategory = TextEditingController();
  var txtId = TextEditingController();
  String date = '';
  int id = 1;

  Future<void> signAccount(String emailAddress,String password)
  async {
    await NotesServices.notesServices.signNoteAccount(emailAddress, password);
    notifyListeners();
  }

  Future<void> loginpagemy(String emailAddress,String password)
  async {
    await NotesServices.notesServices.loginPage(emailAddress, password);
    notifyListeners();
  }

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  // Sync Firestore data to local SQLite with update or insert logic
  Future<void> syncCloudToLocal() async {
    try {
      // Fetch all notes from Firestore
      final snapshot =
      await NotesServices.notesServices.readNotesFromFireStore().first;
      final cloudNotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return NotesModal(
          id: int.parse(data['id'].toString()),
          title: data['title'],
          content: data['content'],
          date: data['date'],
          category: data['category'],
        );
      }).toList();

      // Sync each note from Firestore to local SQLite
      for (var note in cloudNotes) {
        bool exists = await DatabaseHelper.databaseHelper.noteExists(note.id);
        if (exists) {
          // Update the note if it exists
          await DatabaseHelper.databaseHelper.updateNotes(
            note.id,
            note.title,
            note.content,
            note.date,
            note.category,
          );
        } else {
          // Insert the note if it doesn't exist
          await DatabaseHelper.databaseHelper.addNoteToDatabase(
            note.id,
            note.title,
            note.content,
            note.date,
            note.category,
          );
        }
      }

      // Reload local notes list
      await readDataFromDatabase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error syncing data: $e");
    }
  }

  Future<void> addNotesDatabase(int id, String title, String content,
      String date, String category) async {
    await DatabaseHelper.databaseHelper.addNoteToDatabase(
      id,
      title,
      content,
      date,
      category,
    );
    toMap(
      NotesModal(
        id: id,
        title: title,
        content: content,
        category: category,
        date: date,
      ),
    );

    readDataFromDatabase();
    clearAllVar();
    notifyListeners();
  }

  Future<void> addNoteFireStore(NotesModal data) async {
    await NotesServices.notesServices.addNoteToFireStore(
      data.id,
      data.title,
      data.content,
      data.date,
      data.category,
    );
  }

  Future<void> updateDataFromFirestore(NotesModal data) async {
    await NotesServices.notesServices.updateNoteInFireStore(
      data.id,
      data.title,
      data.content,
      data.date,
      data.category,
    );
  }

  Future<void> deleteDataFromFireStore(int id) async {
    await NotesServices.notesServices.deleteNoteFromFireStore(id);
  }

  void clearAllVar() {
    txtCategory.clear();
    txtContent.clear();
    txtTitle.clear();
    date = '';
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readDataFromFireStore() {
    return NotesServices.notesServices.readNotesFromFireStore();
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    return notesList = await DatabaseHelper.databaseHelper.readAllNotes();
  }

  Future<void> updateNoteInDatabase(int id, String title, String content,
      String date, String category) async {
    await DatabaseHelper.databaseHelper.updateNotes(
      id,
      title,
      content,
      date,
      category,
    );
    clearAllVar();
    notifyListeners();
  }

  Future<void> deleteNoteInDatabase(int id) async {
    await DatabaseHelper.databaseHelper.deleteNote(id);
    notifyListeners();
  }

  NotesProvider() {
    initDatabase();
  }


  Future<void> readSearch(String value)
  async {
    await DatabaseHelper.databaseHelper.readNotesByTitle(value);
    notifyListeners();
  }


}
