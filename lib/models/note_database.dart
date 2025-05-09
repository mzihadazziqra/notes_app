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
          ..title = titleFromUser
          ..content = textFromUser
          ..isSynced = false
          ..updatedAt = DateTime.now();

    // Save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

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
      existingNote.content = newText;
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

  // Get unsynced notes
  Future<List<Note>> getUnsyncedNotes() async {
    return await isar.notes.filter().isSyncedEqualTo(false).findAll();
  }

  // Update status isSynced
  Future<void> markNotesAsSynced(int id, int serverID) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      note.isSynced = true;
      note.serverId = serverID;
      await isar.writeTxn(() => isar.notes.put(note));
      await fetchNotes();
    }
  }
}
