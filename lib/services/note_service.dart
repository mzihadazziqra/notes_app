import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/utils/base_url.dart';
import '../models/note.dart';
import 'auth_service.dart';

class NoteService {
  static const String baseUrl = '${BaseUrl.baseUrl}/api/notes';

  static Future<Map<String, String>> _getHeader() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Send note to server
  static Future<int?> createNoteOnServer(Note note) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await _getHeader(),
        body: jsonEncode({'title': note.title, 'content': note.content}),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id']; // Id from server
      } else {
        print('Error when createNoteOnServer. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error when createNoteOnServer: $e');
    }
    return null;
  }

  // Update note on server
  static Future<bool> updateOnServer(Note note) async {
    if (note.serverId == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${note.serverId}'),
        headers: await _getHeader(),
        body: jsonEncode({'title': note.title, 'content': note.content}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error when updateNoteOnServer: $e');
      return false;
    }
  }

  // Delete note on server
  static Future<bool> deleteNoteFromServer(int serverId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$serverId'),
        headers: await _getHeader(),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error when deleteNotefromServer: $e');
      return false;
    }
  }

  static Future<List<Note>> fetchAllNotesFromServer() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeader(),
      );

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
        print('Error when fetchAllNotesFromServer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error when fetchAllNotesFromServer: $e');
    }

    return [];
  }
}
