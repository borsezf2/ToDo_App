import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_app/scopedModel.dart';

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, mainModel)
    {
      return Container(
        height: MediaQuery.of(context).size.height,
        //color: Colors.blue,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height-101,
              child: mainModel.ListNotes.length == 0?Center(child: Text("List is Empty"),): ListView.builder(
                  itemCount:mainModel.ListNotes==null?0:mainModel.ListNotes.length,
                  itemBuilder: (context, index){
                    if(mainModel.ListNotes==null || mainModel.ListNotes.length ==0)
                      return Center(child: Text("List is Empty"),);
                    else
                      {
                        return Dismissible(
                          key: Key(mainModel.ListNotes[index].Note),
                          onDismissed: (val)async{

                            setState(() {
                               print("deleted info = "+ mainModel.ListNotes[index].Priority.toString() +" / "+ mainModel.ListNotes[index].Note);

                            });
                            mainModel.DeleteNote(mainModel.ListNotes[index].Priority,mainModel.ListNotes[index].Note);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),

                            elevation: 15,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(5),
                              title: Text(mainModel.ListNotes[index].Note.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              leading: CircleAvatar(child: Text(mainModel.ListNotes[index].Priority.toString()),backgroundColor: BgColor(mainModel.ListNotes[index].Priority),),
                              
                            ),
                            margin: EdgeInsets.all(6),
                            borderOnForeground: true,
                          ),
                        );
                      }
                  }
              ),
            ),
          ],
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


