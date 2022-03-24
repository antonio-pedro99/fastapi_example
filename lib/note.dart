// ignore: file_names
class Note {
  String? text;
  int? id;
  bool? completed;

  Note({this.id, this.text, this.completed});

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(id: map["id"], text: map["text"], completed: map["completed"]);
  }

  toMap() {
    return {"text": text, "completed": completed};
  }
}
