class Notes {
  int? noteId;
  int? categoryId;
  String?categoryName;
  String? noteTitle;
  String? noteContent;
  String? noteCreatedTime;
  int? notePriority;

  Notes(
      {this.noteId,
      this.categoryId,
      this.noteTitle,
      this.noteContent,
      this.noteCreatedTime,
      this.notePriority});
  Notes.withId(
      {this.noteId,
      this.categoryId,
      this.categoryName,
      this.noteTitle,
      this.noteContent,
      this.noteCreatedTime,
      this.notePriority});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'noteId': noteId,
      'categoryId': categoryId,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'noteCreatedTime': noteCreatedTime,
      'notePriority': notePriority
    };
    if (noteId != null) {
      map['noteId'] = noteId;
      map['categoryId'] = categoryId;
      map['noteTitle'] = noteTitle;
      map['noteContent'] = noteContent;
      map['noteCreatedTime'] = noteCreatedTime;
      map['notePriority'] = notePriority;
    }
    return map;
  }

  Notes.fromMap(Map<String, dynamic> map) {
    noteId = map['noteId'];
    categoryId = map['categoryId'];
    categoryName = map['categoryName'];
    noteTitle = map['noteTitle'];
    noteContent = map['noteContent'];
    noteCreatedTime = map['noteCreatedTime'];
    notePriority = map['notePriority'];
  }

  @override
  String toString() {
    return 'Notes{noteId: $noteId, categoryId: $categoryId, noteTitle: $noteTitle, noteContent: $noteContent, noteCreatedTime: $noteCreatedTime, notePriority: $notePriority}';
  }
}
