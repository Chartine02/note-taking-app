import 'package:flutter/material.dart';
import '../data/notes_repository.dart';
import '../data/note_model.dart';

class NotesProvider with ChangeNotifier {
  final NotesRepository _repo;
  final String uid;
  List<Note> notes = [];
  bool isLoading = false;

  NotesProvider(this._repo, this.uid);

  Future<void> fetchNotes() async {
    isLoading = true;
    notifyListeners();
    try {
      notes = await _repo.fetchNotes(uid);
    } catch (e) {
      // handle error if needed
    }
    isLoading = false;
    notifyListeners();
  }

  Future<String?> addNote(String text) async {
    try {
      await _repo.addNote(uid, text);
      await fetchNotes();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateNote(String id, String text) async {
    try {
      await _repo.updateNote(uid, id, text);
      await fetchNotes();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteNote(String id) async {
    try {
      await _repo.deleteNote(uid, id);
      await fetchNotes();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
