import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fastapi_example/Note.dart';

class Services {
  static Future<List<Note>> fetchNotes() async {
    List<Note> notes = [];

    final response = await http
        .get(Uri.parse('https://notes-backend-flutter.herokuapp.com/notes/'));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      for (var note in jsonList) {
        notes.add(Note.fromJson(note));
      }
      return notes;
    } else {
      throw Exception("Failed to fetch notes");
    }
  }

  static Future<String> createrNote(Note note) async {
    final response = await http.post(
        Uri.parse('https://notes-backend-flutter.herokuapp.com/notes/'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: json.encode(note.toMap()));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to create");
    }
  }

  static Future<String> deleteNote(int noteId) async {
    final response = await http.delete(
        Uri.parse('https://notes-backend-flutter.herokuapp.com/notes/$noteId'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete");
    }
  }

  static Future<String> updateNote(int noteId, bool value) async {
    final response = await http.put(
        Uri.parse('https://notes-backend-flutter.herokuapp.com/notes/$noteId'),
        body: json.encode({"completed": value}));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Can't update");
    }
  }
}
