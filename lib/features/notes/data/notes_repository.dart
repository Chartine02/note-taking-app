import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_model.dart';

class NotesRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Note>> fetchNotes(String uid) async {
    final snap =
        await _db.collection('users').doc(uid).collection('notes').get();
    return snap.docs.map((d) => Note.fromDoc(d)).toList();
  }

  Future<void> addNote(String uid, String text) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .add({'text': text});
  }

  Future<void> updateNote(String uid, String id, String text) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(id)
        .update({'text': text});
  }

  Future<void> deleteNote(String uid, String id) async {
    await _db.collection('users').doc(uid).collection('notes').doc(id).delete();
  }
}
