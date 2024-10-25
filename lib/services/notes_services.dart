// globle database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesServices {
  NotesServices._();

  static NotesServices notesServices = NotesServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNoteToFireStore(int id, String title, String content,
      String date, String category) async {
    await _firestore.collection("notes").doc(id.toString()).set({
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'category': category,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readNotesFromFireStore() {
    return _firestore.collection("notes").snapshots();
  }

  Future<void> deleteNoteFromFireStore(int id) async {
    await _firestore.collection("notes").doc(id.toString()).delete();
  }

  Future<void> updateNoteInFireStore(int id, String title, String content,
      String date, String category) async {
    await _firestore.collection("notes").doc(id.toString()).update({
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'category': category,
    });
  }

  Future<void> loginPage(String emailAddress,String password)
  async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future<void> signNoteAccount(String emailAddress,String password)
  async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

}

