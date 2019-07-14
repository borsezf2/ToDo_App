import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_app/scopedModel.dart';
import 'package:todos_app/todoNotes.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  TextEditingController noteController = new TextEditingController();
  TextEditingController priorityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, mainModel) {
      return
        AlertDialog(
          title: Text("Add Note"),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Note"
                      ),
                      controller: noteController,
                    ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Priority"
                    ),
                    controller: priorityController,
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.blue[100],
              onPressed: () { Navigator.pop(context);},
              child: Text("Close"),
            ),
            RaisedButton(
              padding: EdgeInsets.only(right: 40,left: 40),
              onPressed: () {
                Notes note = new Notes(
                    Note: noteController.text,
                    Priority: int.parse(priorityController.text)
                );
                mainModel.AddNote(note);
                Navigator.pop(context);
              },
              child: Text("Enter",style: TextStyle(color: Colors.white),),
            ),

          ],
        );
      });
  }
}

