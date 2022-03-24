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

  // ignore: non_constant_identifier_names
  static Future<String> deleteNote(int note_id) async {
    final response = await http.delete(Uri.parse(
        'https://notes-backend-flutter.herokuapp.com/notes/$note_id'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete");
    }
  }
}
