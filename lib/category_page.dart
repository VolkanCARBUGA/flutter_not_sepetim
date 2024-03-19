import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_not_sepetim/model/category.dart';
import 'package:flutter_not_sepetim/utils/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var databaseHelper = DatabaseHelper();
  var allCategory = <Category>[];
  var category = Category();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Kategoriler",
            style: GoogleFonts.tillana(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.green),
          ),
          toolbarHeight: 100,
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder<List<Category>>(
            future: databaseHelper.getCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                allCategory = snapshot.data as List<Category>;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: allCategory.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      color: Color.fromARGB(
                        Random().nextInt(255),
                        Random().nextInt(255),
                        Random().nextInt(255),
                        Random().nextInt(255),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shadowColor: Colors.green,
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
                        confirmDismiss: (direction) {
                          return categoryAlertDialog(context);
                        },
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          setState(() {
                            databaseHelper
                                .deleteCategory(allCategory[index].categoryId!);
                            allCategory.removeAt(index);
                          });
                        },
                        child: ListTile(
                          subtitle: Text(
                            textAlign: TextAlign.center,
                            allCategory[index].categoryName!,style: GoogleFonts.tillana(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
                          onTap: () {
                            updateDialog(
                              context,
                              allCategory[index],
                              databaseHelper,
                            );
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center();
              }
            }));
  }

  Future<bool?> categoryAlertDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.red,
          size: 50,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.green),
        ),
        content: Text(
            textAlign: TextAlign.center,
            "Bu kategoriyi silmek istediğinize emin misiniz?",
            style: GoogleFonts.tillana(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        title: Text(
          textAlign: TextAlign.center,
          "Kategori Sil",
          style: GoogleFonts.tillana(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          ElevatedButton.icon(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              label: Text("Evet",
                  style: GoogleFonts.tillana(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ))),
          ElevatedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              label: Text(
                "Hayır",
                style: GoogleFonts.tillana(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ))

        ],
      ),
    );
  }

  void updateDialog(
      BuildContext context, Category category, DatabaseHelper databaseHelper) {
    var controller = TextEditingController(text: category.categoryName);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green),
        ),
        icon: Icon(
          Icons.update_sharp,
          color: Colors.green,
          size: 50,
        ),
        alignment: Alignment.center,
        title: Text("Kategoriyi Düzenle",style: GoogleFonts.tillana(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 17),),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            labelText: "Kategori Adı",
          ),
        ),
        actions: [
          Column(
          
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                            icon: Icon(Icons.check, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                            ),
                            onPressed: () {
                Navigator.pop(context);
                // Kategori adını güncelle
                category.categoryName = controller.text;
                // Veritabanını güncelle
                databaseHelper.updateCategory(category);
                setState(() {});
                            },
                            label: Text(
                "Kaydet",
                style: GoogleFonts.tillana(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                            ),
                          ),
              ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.cancel, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text(
                "Vazgeç",
                style: GoogleFonts.tillana(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              
              icon: Icon(Icons.delete_outline_sharp, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                databaseHelper.deleteCategory(category.categoryId!);
                setState(() {});
              },
              label: Text(
                "Kategori Sil",
                style: GoogleFonts.tillana(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
            ],
          )
        ],
      ),
    );
  }
}
