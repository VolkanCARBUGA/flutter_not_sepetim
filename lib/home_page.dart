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
  var categories = Category();
  var notes = Notes();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var imageUrl = "assets/app_title.png";
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.green),
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.green,

        title: Text(
          "NOT SEPETİM",
          style: GoogleFonts.tillana(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Image.asset(imageUrl,fit: BoxFit.contain,width: 200,height: 100,),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.green),
            ),
            color: Colors.green,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.category_outlined,color: Colors.white,),
                  title: Text(
                    "Kategoriler",
                    style: GoogleFonts.tillana(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                   getCategoryPage();
                  },
                )),
              ];
            },
            onSelected: (value) {
              if (value == "Çıkış") {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: GetNotes(),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: buildButtons(context),
      ),
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.green),
          ),
          padding: const EdgeInsets.all(15),
        ),
        onPressed: () {
          categoryDialog(context);
        },
        child: Text(
          "Kategori Ekle",
          style: GoogleFonts.tillana(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.blue),
            ),
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {
            goToDetailsPage(notes);
          },
          child: Text(
            "Not Ekle",
            style: GoogleFonts.tillana(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          )),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.green),
            ),
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {
            databaseHelper.getNotesList();
            setState(() {});
          },
          child: Text(
            "Yenile",
            style: GoogleFonts.tillana(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ))
    ]);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // String? categoryName = categories.categoryName;
                        if (await databaseHelper
                            .isCategoryExists(categoryName!)) {
                          showSnackbar(
                              "Uyarı",
                              " $categoryName Kategorisi zaten mevcut",
                              ContentType.warning,
                              Colors.red);
                        } else {
                          await databaseHelper
                              .insertCategory(
                                  Category(categoryName: categoryName))
                              .then((value) {
                            categories.categoryId = value;
                          });
                          showSnackbar(
                              "Bilgi",
                              "$categoryName Kategorisi eklendi id: ${categories.categoryId}",
                              ContentType.success,
                              Colors.green);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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

  void showSnackbar(
      String title, String mesage, ContentType contentType, Color color) {
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

  void goToDetailsPage(Notes notes) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteDetails(
                title: "Yeni Not",
                notes: notes,
              )),
    );
  }
}

void getCategoryPage() {
  
}
