import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_sepetim/model/notes.dart';
import 'package:flutter_not_sepetim/note_details.dart';
import 'package:flutter_not_sepetim/utils/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class GetNotes extends StatefulWidget {
  const GetNotes({Key? key}) : super(key: key);

  @override
  State<GetNotes> createState() => _GetNotesState();
}

class _GetNotesState extends State<GetNotes> {
  var allNotes = <Notes>[];
  var databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: databaseHelper.getNotesList(),
        builder: (context, AsyncSnapshot<List<Notes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            allNotes = snapshot.data!;
            return ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(10),
                      color: Color.fromARGB(
                          Random().nextInt(255),
                          Random().nextInt(255),
                          Random().nextInt(255),
                          Random().nextInt(255)),
                      child: Dismissible(
                        background: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) {
                          return showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  alignment: Alignment.center,
                                  title: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 100,
                                  ),
                                  content: Text(
                                    "${allNotes[index].noteTitle} silinsin mi?",
                                    style: GoogleFonts.tillana(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text(
                                          "Hayır",
                                          style: GoogleFonts.tillana(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20),
                                        )),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text(
                                          "Evet",
                                          style: GoogleFonts.tillana(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20),
                                        ))
                                  ],
                                );
                              });
                        },
                        onDismissed: (direction) {
                          databaseHelper
                              .deleteNote(allNotes[index].noteId!)
                              .then((value) {
                            setState(() {
                              allNotes.removeAt(index);
                            });
                          });
                        },
                        child: noteList(index),
                      ));
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ExpansionTile noteList(int index) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.all(10),
      leading: priorityIcon(allNotes[index].notePriority!),
      title: Text(
        textAlign: TextAlign.center,
        allNotes[index].noteTitle.toString(),
        style: GoogleFonts.tillana(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
      ),
      children: [expansionTileItem(index)],
    );
  }

  Container expansionTileItem(int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kategori :",
                style: GoogleFonts.tillana(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                allNotes[index].categoryName.toString(),
                style: GoogleFonts.tillana(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 3,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oluşturma Tarihi : ",
                style: GoogleFonts.tillana(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                databaseHelper.dateFormat(
                    DateTime.parse(allNotes[index].noteCreatedTime!)),
                style: GoogleFonts.tillana(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 3,
            color: Colors.black,
          ),
          Text(
            allNotes[index].noteContent.toString(),
            style: GoogleFonts.tillana(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
          ),
          Divider(
            height: 10,
            thickness: 3,
            color: Colors.black,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.green),
                      )),
                  icon: Icon(
                    Icons.update_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    goToDetailsPage(context, allNotes[index]);
                  },
                  label: Text(
                    "Güncelle",
                    style: GoogleFonts.tillana(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.red),
                      )),
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    deleteNoteAlertDialog(index);
                  },
                  label: Text(
                    "Sil",
                    style: GoogleFonts.tillana(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void deleteNoteAlertDialog(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          icon: Icon(
            Icons.warning,
            color: Colors.red,
          ),
          title: Text(
            textAlign: TextAlign.center,
            "Not Sil",
            style: GoogleFonts.tillana(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            textAlign: TextAlign.center,
            "Emin misiniz?",
            style: GoogleFonts.tillana(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red),
                        )),
                    icon: Icon(
                      Icons.delete_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      deleteNote(index, context);
                    },
                    label: Text(
                      "Sil",
                      style: GoogleFonts.tillana(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.green),
                        )),
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text("Vazgeç",
                        style: GoogleFonts.tillana(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))),
              ],
            )
          ],
        );
      },
    );
  }

  void deleteNote(int index, BuildContext context) {
    databaseHelper.deleteNote(allNotes[index].noteId!).then((value) {
      Navigator.pop(context);
      setState(() {
        allNotes.removeAt(index);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.white,
        content: AwesomeSnackbarContent(
            title: "Bilgi",
            message: "${allNotes[index].noteTitle} Notu Silindi",
            contentType: ContentType.success)));
            
  }
}
void goToDetailsPage(BuildContext context,Notes notes) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteDetails(
                title: "Notunu Düzenle",
                notes: notes,
              )),
    );
  }
priorityIcon(int priority) {
  if (priority == 0) {
    return CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(
          "Düşük",
          style: GoogleFonts.tillana(fontSize: 15, color: Colors.black),
        ));
  } else if (priority == 1) {
    return CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          "Orta",
          style: GoogleFonts.tillana(fontSize: 15, color: Colors.black),
        ));
  } else if (priority == 2) {
    return CircleAvatar(
      backgroundColor: Colors.red,
      child: Text(
        "Yüksek",
        style: GoogleFonts.tillana(fontSize: 13, color: Colors.black),
      ),
    );
  }
}
