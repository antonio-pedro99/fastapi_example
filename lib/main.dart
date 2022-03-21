import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Person {
  String? name;
  int? age;

  Person({this.name, this.age});

  factory Person.fromJson(Map<String, dynamic> map) {
    return Person(age: map["age"], name: map["name"]);
  }
}

class Note {
  String? text;
  int? id;
  bool? completed;

  Note({this.id, this.text, this.completed});

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(id: map["id"], text: map["text"], completed: map["completed"]);
  }
}

Future<List<Note>> fetchNotes() async {
  List<Note> notes = [];

  final response = await http.get(Uri.parse('https://notes-backend-flutter.herokuapp.com/notes/'));

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Note>> notes;
  @override
  void initState() {
    super.initState();
    notes = fetchNotes();
  }

  Future<Null> organize() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      notes = fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder<List<Note>>(
            future: notes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        late bool? status = snapshot.data![index].completed;
                        return ListTile(
                          title: Text("${snapshot.data![index].text}"),
                          subtitle:
                              Text(status! ? "Completed" : "Not Completed"),
                        );
                      },
                    ),
                    onRefresh: organize);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )));
  }
}
