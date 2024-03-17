// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_sepetim/get_notes.dart';
import 'package:flutter_not_sepetim/model/category.dart';
import 'package:flutter_not_sepetim/model/notes.dart';
import 'package:flutter_not_sepetim/note_details.dart';
import 'package:flutter_not_sepetim/utils/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var databaseHelper = DatabaseHelper();
  var notes = Notes();
  var notesList = <Notes>[];
  var categories = Category();
  var categoriesList = <Category>[];
  var scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter Not Sepetim'),
          centerTitle: true,
        ),
        body: GetNotes(),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FloatingActionButton.extended(
            heroTag: "tag2",
            icon: const Icon(Icons.add_circle_outline_rounded),
            backgroundColor: Colors.blue,
            onPressed: () {
              categoryDialog(context);
            },
            label: Text(
              "Kategori Ekle",
              style: GoogleFonts.tillana(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: "tag1",
              backgroundColor: Colors.green,
              icon: const Icon(Icons.add_task_rounded),
              onPressed: () {
               goToDetailsPage();
              },
              label: Text(
                "Not Ekle",
                style: GoogleFonts.tillana(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        ])
        
        );
  }

  void categoryDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String? categoryName;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: Text(
            "Kategori Ekle",
            style:
                GoogleFonts.tillana(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (newValue) {
                    categoryName = newValue;
                  },
                  onChanged: (value) {
                    categories.categoryName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori Adı',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        )),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return "Kategori Adı  Çok kısa veya boş";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
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
                          color: Colors.blue,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // String? categoryName = categories.categoryName;
                        if (await databaseHelper
                            .isCategoryExists(categoryName!)) {
                          showSnackbar("Uyarı"," $categoryName Kategorisi zaten mevcut", ContentType.warning, Colors.red);
                        }else {
                          await databaseHelper.insertCategory(Category(
                            categoryName:
                                categoryName)).then((value) {
                                categories.categoryId = value;
                                });
                        showSnackbar("Bilgi", "$categoryName Kategorisi eklendi id: ${categories.categoryId}", ContentType.success, Colors.green); 
                        }
                      
                        
                        Navigator.pop(context);
                      }
                    },
                    label: Text(
                      "Kaydet",
                      style: GoogleFonts.tillana(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                ElevatedButton.icon(
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    label: Text(
                      "İptal Et",
                      style: GoogleFonts.tillana(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        );
      },
    );
  }

  void showSnackbar(String title, String mesage, ContentType contentType,
      Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.white,
          content: AwesomeSnackbarContent(
              title: title,
              color: color,
              message: mesage,
              contentType: contentType)),
    );
  }
  void goToDetailsPage() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  NoteDetails(title: "Yeni Not",)),
  );
}
}
