import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:flutter_note_app/screens/edit_note.dart';
import 'package:flutter_note_app/screens/view_note.dart';
import 'package:flutter_note_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Note note = Note('', '', '');
  List<Note> noteList;
  int _count = 0;
  DatabaseHelper _helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateNoteListView();
    }
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Center(child: Text('Not Defteri',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
      ),
      backgroundColor: Color(0xffb7e4c7),
      body:
      showNoteList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),

        onPressed: () {
          goToNoteDetails();
        },
      ),
    );
  }

  void goToNoteDetails() async {
    bool response = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateNote(Note('', '', ''))));
    if (response == true) {
      updateNoteListView();
    }
  }

  Widget showNoteList() {
    var listView = ListView.builder(
      itemCount: _count,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.black,
            ),
            title: Text(
              this.noteList[index].title,
              style: TextStyle(fontFamily: 'amaranth', fontSize: 20.0),
            ),
            subtitle: Text(
              this.noteList[index].date,
              style: TextStyle(
                  fontFamily: 'caveat',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.blueGrey,
              ),
              onTap: () {
                _delete(context, noteList[index]);
              },
            ),
            onTap: () {
              _viewNote(noteList[index]);
            },
          ),
          color: Color(0xffd8f3dc),
          elevation: 12.0,
        );
      },
    );
    return listView;
  }

  void updateNoteListView() {
    final Future<Database> dbFuture = _helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = _helper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this._count = noteList.length;
        });
      });
    });
  }

  void _delete(BuildContext context, Note note) async {
    int response = await _helper.delete(note.id);
    if (response != 0) {
      updateNoteListView();
    }
  }

  void _viewNote(Note note) async {
    bool response = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewNote(note)));
    if (response) {
      updateNoteListView();
    }
  }
}
