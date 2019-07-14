import 'package:scoped_model/scoped_model.dart';
import 'package:todos_app/database_helper.dart';
import 'package:todos_app/database_helper2.dart';
import 'package:todos_app/todoNotes.dart';

class MainModel extends Model
{
  DatabaseHelper databaseHelper = DatabaseHelper();
  DatabaseHelper2 databaseHelper2 = DatabaseHelper2();

  MainModel()
  {
    getListOnStartup();
  }

  getListOnStartup() async
  {
     List<Notes> ListNotesSql = await databaseHelper.getNoteList() ;
     List<Notes> DeletedNotesSql = await databaseHelper2.getDeletedList() ;
     ListNotes = ListNotesSql ;
     DeletedNotes = DeletedNotesSql;
     notifyListeners();
  }

  List<Notes> ListNotes = [
//    Notes(
//        Note: "These are some sample Notes ",
//        Priority: 2
//    ),
//    Notes(
//      Note: "Buy vegitables from market",
//      Priority: 3
//    ),
//    Notes(
//        Note: "Swipe L/R to Delete",
//        Priority: 8
//    ),
//    Notes(
//        Note: "All the completed task will be in Deleted section which can be accessed by the delete button at the top",
//        Priority: 13
//    ),
  ] ;

  List<Notes> DeletedNotes = [] ;

  void AddNote(Notes note) async
  {

    databaseHelper.insertNote(note);
    ListNotes = await databaseHelper.getNoteList() ;
    //ListNotes.add(note);
    ListNotes.sort((a,b)=> (a.Priority.compareTo(b.Priority)));
        notifyListeners();
  }

  void DeleteNote(int priority,String note)async{
    Notes post = new Notes(
      Priority: priority,
      Note: note.toString(),
    );
    ListNotes.removeWhere((p)=>(p.Note==note && p.Priority== priority));

    databaseHelper.insertNoteDeleted(post);
    databaseHelper.deleteNote(priority,note.toString());
    DeletedNotes = await databaseHelper2.getDeletedList() ;
//    DeletedNotes.add(post);
//    getListOnStartup();
//    print("ListNote length " + ListNotes.length.toString());
//    print("DelNote length " + DeletedNotes.length.toString());
    notifyListeners();

  }

  void ReAddNote(Notes note)
  {
    AddNote(note);
    databaseHelper2.deleteNote(note.Priority, note.Note);
    DeletedNotes.removeWhere((p)=>(p.Note==note.Note && p.Priority== note.Priority));
    notifyListeners();
  }

  void DeletePermanent(Notes note)async{
    DeletedNotes.removeWhere((p)=>(p.Note==note.Note && p.Priority== note.Priority));
    databaseHelper2.deleteNote(note.Priority, note.Note);
    DeletedNotes = await databaseHelper2.getDeletedList() ;

    notifyListeners();

  }

  void DeleteAll()async{
//    DeletedNotes.removeWhere((p)=>(p.Note==note.Note && p.Priority== note.Priority));
    databaseHelper2.deleteAll();
    DeletedNotes = await databaseHelper2.getDeletedList() ;

    notifyListeners();

  }

}