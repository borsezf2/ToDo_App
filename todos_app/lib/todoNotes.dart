
class Notes
{
  String Note;
  int Priority;

  Notes({this.Note,this.Priority});



  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    map['note'] = Note;
    map['priority'] = Priority;


    return map;
  }

  // Extract a Note object from a Map object
  Notes.fromMapObject(Map<String, dynamic> map) {
    this.Priority = map['priority'];
    this.Note = map['note'];
  }
}


