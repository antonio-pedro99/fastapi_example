import 'package:fastapi_example/service.dart';
import 'package:flutter/material.dart';

import 'Note.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Note>> notes;

  @override
  void initState() {
    super.initState();
    notes = Services.fetchNotes();
  }

  List<Note>? search(String text) {
    notes.then((value) {
      List<Note>? result;
      int index = value.indexWhere((element) => element.text == text);
      Note note = value[index];
      result!.add(note);
      value = result;
    });

    return null;
  }

  Future<Null> organize() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      notes = Services.fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerText = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(hintText: "Search"),
          controller: controllerText,
          onChanged: (value) {
            setState(() {
              print("Hello");
            });
          },
        ),
        centerTitle: true,
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
                      return InkWell(
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            height: 80,
                            child: ListTile(
                              title: Text(
                                "${snapshot.data![index].text}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              leading: CircleAvatar(
                                  child: Icon(
                                status! ? Icons.check : Icons.error,
                                size: 40,
                              )),
                              subtitle:
                                  Text(status ? "Completed" : "Not Completed"),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Note note = snapshot.data![index];
                                      Services.deleteNote(note.id!);
                                      organize();
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        onLongPress: () {
                          setState(() {
                            Note _note = snapshot.data![index];

                            Services.updateNote(
                                _note.id!, _note.completed! ? true : false);
                          });
                        },
                      );
                    },
                  ),
                  onRefresh: organize);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      )),
    );
  }
}
