import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:flutter_note_app/screens/edit_note.dart';
import 'package:flutter_note_app/utils/database_helper.dart';

class ViewNote extends StatefulWidget {
  final Note note;

  ViewNote(this.note);

  @override
  _ViewNoteState createState() => _ViewNoteState(this.note);
}

class _ViewNoteState extends State<ViewNote> {
  DatabaseHelper _helper = DatabaseHelper();
  Note note;

  _ViewNoteState(this.note);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            goToLastScreen();
          }),
      title: Text('Girilmiş Not'),
      actions: <Widget>[
        FlatButton(
          child: Icon(
            Icons.edit,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _editNote(context);
            });
          },
        ),
      ],
    );
    return WillPopScope(
      onWillPop: () {
        goToLastScreen();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Color(0xffb7e4c7),
        body: ListView(
          children: <Widget>[
            Card(
              child: Container(
                height: 75.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                  child: Text(
                    this.note.title,
                    style: TextStyle(fontFamily: 'Amaranth', fontSize: 20.0),
                  ),
                ),
              ),
              color: Color(0xffb7e4c7),
              elevation: 3.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.note.content,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'redHat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateNote() async {
    Note note = await _helper.getNoteById(this.note.id);
    setState(() {
      this.note = note;
    });
  }

  void goToLastScreen() {
    Navigator.pop(context, true);
  }

  void _editNote(context) async {
    bool response = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateNote(this.note)));
    if (response) {
      print(response.toString());
      updateNote();
    }
  }
}
