import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';
import 'masnoon_dua_view.dart';

class DuaCategoryScreen extends StatelessWidget {
  const DuaCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DuaController duaController = Get.find<DuaController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Dua Categories",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: duaController.categories.length,
          itemBuilder: (context, index) {
            final category = duaController.categories[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade50,
              ),
              child: ListTile(
                title: Text(
                  category.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: category.isUserAdded
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                duaController.showDeleteCategoryDialog(
                                    context, category.name),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => duaController
                                .showEditCategoryDialog(context, category.name),
                          ),
                        ],
                      )
                    : const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Get.to(() => DuaScreen(categoryName: category.name));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddCategoryDialog(context, duaController),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showAddCategoryDialog(
      BuildContext context, DuaController duaController) {
    final TextEditingController categoryController = TextEditingController();
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "Add New Category",
      content: Column(
        children: [
          TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: "Enter category name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                duaController.categories.add(DuaCategoryModel(
                  name: categoryController.text,
                  duas: [],
                  isUserAdded: true,
                ));
                duaController.saveDuaCategories();
                Get.back();
              }
            },
            child: const Text(
              "Add Category",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
