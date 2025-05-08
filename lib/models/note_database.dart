import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize the database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // LIst of notes
  final List<Note> currentNotes = [];

  // Create
  Future<void> addNote(String titleFromUser, String textFromUser) async {
    // Create a new note object
    final newNote =
        Note()
          ..text = textFromUser
          ..title = titleFromUser;

    // Save to db
    await isar.writeTxn(() => isar.notes.put(newNote));
    // print('Note added: ${newNote.title}');

    // re-read from db
    await fetchNotes();
  }

  // Read
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

  // Update
  Future<void> updateNotes(int id, String newTitle, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      existingNote.title = newTitle;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // Delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
