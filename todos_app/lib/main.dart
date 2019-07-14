import 'package:flutter/material.dart';
import 'package:todos_app/ListWidget.dart';
import 'package:todos_app/addNote.dart';
import 'package:todos_app/backCurve.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_app/database_helper.dart';
import 'package:todos_app/deletedNotes.dart';
import 'package:todos_app/scopedModel.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final MainModel mainModelObj = MainModel();




  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModelObj,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  final MainModel mainModelObj = MainModel();

  @override
  Future initState()  {
    // TODO: implement initState
    super.initState();
    getList();
  }

  getList () async
  {
    mainModelObj.ListNotes = await databaseHelper.getNoteList() ;
    print(" note sql = "+mainModelObj.ListNotes[1].Note);
    setState(() {
      mainModelObj.ListNotes = mainModelObj.ListNotes ;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          Align(
            alignment: Alignment.topCenter,
            child: ListWidget(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: BackCurve(),
          ),
          Align(
            alignment: Alignment(1, -0.9),
            child: IconButton(
                icon: Icon(Icons.delete_outline,color: Colors.white,size: 30,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DeletedNotes()));
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context,builder: (context)=>AddNote());
          },
        child: Icon(Icons.add),
          ),
    );
  }
}
