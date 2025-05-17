import 'package:isar/isar.dart';

import '../core/utils/network_helper.dart';
import '../db/app_database.dart';
import '../db/note_database.dart';
import '../models/note.dart';
import 'note_service.dart';

class SyncService {
  // Sync notes that have not been synced to the server
  static Future<void> syncToServer(NoteDatabase noteDb) async {
    final connected = await NetworkHelper.hasInternetConnection();
    if (!connected) {
      print('No internet connection, skip syncToServer');
      return;
    }
    for (Note note in noteDb.currentNotes) {
      if (!note.isSynced) {
        if (note.serverId == null) {
          // New note, send POST
          final serverId = await NoteService.createNoteOnServer(note);
          if (serverId != null) {
            note.serverId = serverId;
            note.isSynced = true;
            await noteDb.isar.writeTxn(() => noteDb.isar.notes.put(note));
          }
        } else {
          // Existing note, update with PUT
          final success = await NoteService.updateOnServer(note);
          if (success) {
            note.isSynced = true;
            await noteDb.isar.writeTxn(() => noteDb.isar.notes.put(note));
          }
        }
      }
    }
  }

  // Sync note from server to local
  static Future<void> syncFromServer(NoteDatabase noteDb) async {
    final connected = await NetworkHelper.hasInternetConnection();
    final notesFromServer = await NoteService.fetchAllNotesFromServer();
    if (!connected) {
      print('No internet connection, skip syncFromServer');
    }
    for (Note note in notesFromServer) {
      final existing =
          await noteDb.isar.notes
              .filter()
              .serverIdEqualTo(note.serverId)
              .build()
              .findFirst();
      if (existing == null) {
        await NoteDatabase(AppDatabase.isar).isar.writeTxn(
          () => NoteDatabase(AppDatabase.isar).isar.notes.put(note),
        );
      } else {
        // if 'updateAt' from server is newer, replace
        if (note.updatedAt.isAfter(existing.updatedAt)) {
          note.id = existing.id;
          await noteDb.isar.writeTxn(() => noteDb.isar.notes.put(note));
        }
      }
    }
    await noteDb.fetchNotes();
  }
}
