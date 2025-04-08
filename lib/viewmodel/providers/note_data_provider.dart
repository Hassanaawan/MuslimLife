import 'package:flutter/cupertino.dart';
import '../../services/db_helper.dart';
import '../../models/note_model.dart';

class NoteDataProvider extends ChangeNotifier {
  List<NoteModel> noteList = [];

  Future<int> insertNote(NoteModel noteModel) =>
      DbHelper.insertNote(noteModel);

  void getAllNotes() async {
    noteList = await DbHelper.getAllNotes();
    notifyListeners();
  }

  Future<int> deleteNotes() =>
      DbHelper.deleteNotes();

}