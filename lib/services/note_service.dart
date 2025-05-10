import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/note.dart';

class NoteService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/notes';

  // Send note to server
  static Future<int?> createNoteOnServer(Note note) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': note.title, 'content': note.content}),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id']; // Id from server
      } else {
        print('Gagal membuat note di server. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat createNoteOnServer: $e');
    }
    return null;
  }

  // Update note on server
  static Future<bool> updateOnServer(Note note) async {
    if (note.serverId == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${note.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': note.title, 'content': note.content}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error saat updateNoteOnServer: $e');
      return false;
    }
  }

  // Delete note on server
  static Future<bool> deleteNoteFromServer(int serverId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$serverId'));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error saat deleteNotefromServer: $e');
      return false;
    }
  }

  static Future<List<Note>> fetchAllNotesFromServer() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) {
          return Note()
            ..title = json['title']
            ..content = json['content']
            ..updatedAt = DateTime.parse(json['updated_at'])
            ..createdAt = DateTime.parse(json['created_at'])
            ..serverId = json['id']
            ..isSynced = true;
        }).toList();
      } else {
        print('Gagal mengambil data dari server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat fetchAllNotesFromServer: $e');
    }

    return [];
  }
}
