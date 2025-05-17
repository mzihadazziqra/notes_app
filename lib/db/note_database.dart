import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import '../services/sync_service.dart';

class NoteDatabase extends ChangeNotifier {
  final Isar isar;

  NoteDatabase(this.isar);

  // List of notes
  final List<Note> currentNotes = [];

  // Create
  Future<void> addNote(String titleFromUser, String textFromUser) async {
    // Create a new note object
    final newNote =
        Note()
          ..title = titleFromUser
          ..content = textFromUser
          ..updatedAt = DateTime.now()
          ..createdAt = DateTime.now()
          ..isSynced = false;

    // Save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read from db
    await fetchNotes();

    // Sync data to server after add note
    await SyncService.syncToServer(this);
  }

  // Read
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes
      ..clear()
      ..addAll(fetchNotes);
    notifyListeners();
  }

  // Update
  Future<void> updateNotes(int id, String newTitle, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote
        ..title = newTitle
        ..content = newText
        ..updatedAt = DateTime.now()
        ..createdAt = DateTime.now()
        ..isSynced = false;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();

      // Run sync after update the data
      await SyncService.syncToServer(this);
    }
  }

  // Delete
  Future<void> deleteNote(int id) async {
    final note = await isar.notes.get(id);

    if (note != null && note.serverId != null) {
      // Delete from server
      await NoteService.deleteNoteFromServer(note.serverId!);
    }

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
      note
        ..isSynced = true
        ..serverId = serverID;
      await isar.writeTxn(() => isar.notes.put(note));
      await fetchNotes();
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.notes.clear();
    });
  }
}
