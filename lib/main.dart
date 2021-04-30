import 'package:flutter/material.dart';
import 'package:flutter_note_app/screens/note_list.dart';
void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Not Uygulaması",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NoteList(),
    );
  }
}
