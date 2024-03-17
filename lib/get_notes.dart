import 'package:flutter/material.dart';
import 'package:flutter_not_sepetim/model/notes.dart';
import 'package:flutter_not_sepetim/utils/database_helper.dart';

class GetNotes extends StatefulWidget {
  const GetNotes({super.key});

  @override
  State<GetNotes> createState() => _GetNotesState();
}

class _GetNotesState extends State<GetNotes> {
  var allNotes=<Notes>[];
  var databaseHelper = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.getNotes().then((value) {
      for(var note in value){
        allNotes.add(Notes.fromMap(note));
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
