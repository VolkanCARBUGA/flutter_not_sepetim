// ignore_for_file: must_be_immutable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_sepetim/model/category.dart';
import 'package:flutter_not_sepetim/model/notes.dart';
import 'package:flutter_not_sepetim/notification_helper.dart';
import 'package:flutter_not_sepetim/utils/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteDetails extends StatefulWidget {
  // Notes notes;
  String title;
  Notes notes;
  NoteDetails({super.key, required this.title, required this.notes});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  var formKey = GlobalKey<FormState>();
  var allCategories = <Category>[];
  late DatabaseHelper databaseHelper;
  int? categoryId=1 ;
  int? priority=0 ;
  static var oncelik = ["Düşük", "Orta", "Yüksek"];
  String? noteTitle, noteContent;
  var currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  allCategories = <Category>[];
  databaseHelper = DatabaseHelper();
  databaseHelper.getCategory().then((value) {
    for (var category in value) {
      allCategories.add(Category.fromMap(category.toMap()));
    }
    // Varsayılan kategori ve öncelik seçimi burada yapılabilir
    if (allCategories.isNotEmpty) {
      categoryId = allCategories.first.categoryId;
    }
    priority = 0; // Varsayılan olarak öncelik sırası düşük olarak ayarlandı
    setState(() {});
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
          side: const BorderSide(color: Colors.green),
        ),
        toolbarHeight: 100,
       
          title: Text(
            widget.title,
           style: GoogleFonts.tillana(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          ),
          centerTitle: true,
        ),
        body: allCategories.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Kategori",
                                style: GoogleFonts.tillana(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 6),
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.deepPurple, width: 2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: categoryId,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: dropDownMenuItem(),
                                      onChanged: (value) {
                                        setState(() {
                                          categoryId = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.notes != null
                                ? widget.notes.noteTitle
                                : " ",
                            validator: (value) {
                              if (value!.isEmpty && value.length < 5) {
                                return "Notunuz çok kısa yada boş";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              noteTitle = newValue;
                            },
                            decoration: InputDecoration(
                              labelText: 'Notunuzu yazın',
                              labelStyle: GoogleFonts.tillana(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.deepPurple,
                                      width: 2)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.notes != null
                                ? widget.notes.noteContent
                                : " ",
                            onSaved: (newValue) {
                              noteContent = newValue;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Notunuzun açıklamasını yazın',
                              labelStyle: GoogleFonts.tillana(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.deepPurple,
                                      width: 2)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text("Öncelik Sırası",
                                style: GoogleFonts.tillana(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 6),
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.deepPurple, width: 2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: priority,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: oncelik
                                          .map((e) => DropdownMenuItem(
                                              value: oncelik.indexOf(e),
                                              child: Text(e,style: GoogleFonts.tillana(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold
                                              ),)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          priority = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        buildButton(context),
                      ],
                    )),
              ));
  }

  ButtonBar buildButton(BuildContext context) {
    return ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.green,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                
                  saveNote();
                     setState(() {});
                  
                

              
              
              }
            },
            label: Text("Kaydet",
                style: GoogleFonts.tillana(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text("Vazgeç",
                style: GoogleFonts.tillana(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          )
        ]);
  }

 
  List<DropdownMenuItem<int>> dropDownMenuItem() {
    var categoryList = <DropdownMenuItem<int>>[];

    for (var category in allCategories) {
      categoryList.add(DropdownMenuItem(
        value: category.categoryId,
        child: Text(
          category.categoryName!,
          style: GoogleFonts.tillana(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ));
    }

    return categoryList;
  }

  void saveNote() {
    databaseHelper
        .insertNote(Notes(
            noteTitle: noteTitle,
            noteContent: noteContent,
            noteCreatedTime: currentDate.toString(),
            notePriority: priority,
            categoryId: categoryId))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: AwesomeSnackbarContent(
                title: "Başarılı",
                message: " $noteTitle Kaydedildi",
                contentType: ContentType.success))));
    print("Eklenen id: $categoryId Eklenen Tarih: $currentDate");
    print("Eklewnen zamana: ${databaseHelper.dateFormat(currentDate)}");
    NotificationHelper().showNotification( title: noteTitle!, body: noteContent!);

    Navigator.pop(context);
  }
}
