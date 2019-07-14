import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_app/scopedModel.dart';

class DeletedNotes extends StatefulWidget {
  @override
  _DeletedNotesState createState() => _DeletedNotesState();
}

class _DeletedNotesState extends State<DeletedNotes> {
  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<MainModel>(
        builder: (context, child, mainModel)
    {
      return
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Completed Tasks"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.delete_sweep), onPressed: (){
                showDialog(context: context,builder: (context)=>AlertDialog(
                  title: Text("Delete All Records"),
                  content: Text("All the Completed History will be deleted permanently"),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text(" No "),
                        color: Colors.blue[100],
                        onPressed: (){
                        Navigator.pop(context);
                        }),
                    RaisedButton(
                      padding: EdgeInsets.all(20),
                        child: Text(" Yes, Delete'em All",style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          mainModel.DeleteAll();

                          Navigator.pop(context);

                        })
                  ],
                ));
//                mainModel.DeleteAll();
              })
            ],
          ),
          body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: ListView.builder(
                itemCount:mainModel.DeletedNotes.length==0?0:mainModel.DeletedNotes.length,
                itemBuilder: (context, index) {
                    return Card(
                      elevation: 15,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(mainModel.DeletedNotes[index].Note.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        leading: CircleAvatar(child: Text(mainModel.DeletedNotes[index].Priority.toString()),backgroundColor: BgColor(mainModel.DeletedNotes[index].Priority),),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: (){
//                              mainModel.AddNote(mainModel.DeletedNotes[index]);
                                  mainModel.ReAddNote(mainModel.DeletedNotes[index]);
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Re-Added the Item")));
                                }),
                            IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: (){
//                              mainModel.AddNote(mainModel.DeletedNotes[index]);
                                  mainModel.DeletePermanent(mainModel.DeletedNotes[index]);
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("permanently deleted")));
                                }),
                          ],
                        ),
                      ),
                    );
                }),
          ),
        );
    });
  }

  BgColor(p)
  {
    if(p<=5)
      return Colors.redAccent ;
    else if (5<p && p<10)
      return Colors.green ;
    else
      return Colors.blue ;

  }
}
