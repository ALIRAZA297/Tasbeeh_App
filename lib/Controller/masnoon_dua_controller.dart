// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';

// class DuaController extends GetxController {
//   var duas = <DuaModel>[].obs;
//   final String _storageKey = "saved_duas";

//   @override
//   void onInit() {
//     super.onInit();
//     loadDuas();
//   }

//   Future<void> loadDuas() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedDuas = prefs.getString(_storageKey);

//     if (savedDuas != null) {
//       List<dynamic> decodedList = jsonDecode(savedDuas);
//       duas.assignAll(decodedList.map((e) => DuaModel.fromJson(e)).toList());
//     } else {
//       // If no saved data, load default duas
//       duas.assignAll([
//         DuaModel(
//           title: "صبح کی دعا",
//           dua: "اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك المصير",
//           translationUrdu: "اے اللہ! تیرے ہی حکم سے ہم نے صبح کی",
//           translationEnglish: "O Allah, by You we enter the morning",
//           icon: Icons.wb_sunny,
//         ),
//         DuaModel(
//           title: "کھانے سے پہلے کی دعا",
//           dua: "اللهم بارك لنا فيما رزقتنا وقنا عذاب النار",
//           translationUrdu: "اے اللہ! ہمارے دیے گئے رزق میں برکت عطا فرما",
//           translationEnglish: "O Allah, bless us in what You have provided",
//           icon: Icons.fastfood,
//         ),
//       ]);
//       saveDuas();
//     }
//   }

//   Future<void> saveDuas() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<Map<String, dynamic>> duaList =
//         duas.map((dua) => dua.toJson()).toList();
//     await prefs.setString(_storageKey, jsonEncode(duaList));
//   }

//   void addDua(DuaModel dua) {
//     duas.add(dua);
//     saveDuas();
//   }

//   void deleteDua(int index) {
//     duas.removeAt(index);
//     saveDuas();
//   }

//   void editDua(int index, DuaModel updatedDua) {
//     duas[index] = updatedDua;
//     saveDuas();
//   }

//   void showAddDuaDialog(BuildContext context) {
//     final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//     final TextEditingController titleController = TextEditingController();
//     final TextEditingController duaControllerArabic = TextEditingController();
//     final TextEditingController translationUrduController = TextEditingController();
//     final TextEditingController translationEnglishController = TextEditingController();

//     Get.defaultDialog(
//       backgroundColor: Colors.white,
//       title: "Add New Dua",
//       content: Form(
//         key: formKey,
//         child: Column(
//           children: [
//             buildTextField(titleController, "Title", true),
//             buildTextField(duaControllerArabic, "Dua in Arabic", true),
//             buildTextField(translationUrduController, "Translation (Urdu) (optional)", false),
//             buildTextField(translationEnglishController, "Translation (English) (optional)", false),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   addDua(DuaModel(
//                     title: titleController.text,
//                     dua: duaControllerArabic.text,
//                     translationUrdu: translationUrduController.text.isEmpty ? '' : translationUrduController.text,
//                     translationEnglish: translationEnglishController.text.isEmpty ? '' : translationEnglishController.text,
//                     icon: Icons.save, // Default icon for user-added Duas
//                     isUserAdded: true,
//                   ));
//                   Get.back();
//                 }
//               },
//               child: Text("Add Dua", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showEditDuaDialog(BuildContext context, int index, DuaModel dua) {
//     final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//     final TextEditingController titleController = TextEditingController(text: dua.title);
//     final TextEditingController duaControllerArabic = TextEditingController(text: dua.dua);
//     final TextEditingController translationUrduController = TextEditingController(text: dua.translationUrdu ?? "");
//     final TextEditingController translationEnglishController = TextEditingController(text: dua.translationEnglish ?? "");

//     Get.defaultDialog(
//       backgroundColor: Colors.white,
//       title: "Edit Dua",
//       content: Form(
//         key: formKey,
//         child: Column(
//           children: [
//             buildTextField(titleController, "Title", true),
//             buildTextField(duaControllerArabic, "Dua in Arabic", true),
//             buildTextField(translationUrduController, "Translation (Urdu)  (optional)", false),
//             buildTextField(translationEnglishController, "Translation (English) (optional)", false),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   editDua(
//                     index,
//                     DuaModel(
//                       title: titleController.text,
//                       dua: duaControllerArabic.text,
//                       translationUrdu: translationUrduController.text.isEmpty ? '' : translationUrduController.text,
//                       translationEnglish: translationEnglishController.text.isEmpty ? '' : translationEnglishController.text,
//                       icon: dua.icon,
//                       isUserAdded: true,
//                     ),
//                   );
//                   Get.back();
//                 }
//               },
//               child: Text("Save Changes", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(TextEditingController controller, String hint, bool isRequired) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) {
//           if (isRequired && (value == null || value.trim().isEmpty)) {
//             return "$hint is required";
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   void showDeleteConfirmationDialog(BuildContext context, int index) {
//     Get.defaultDialog(
//       title: "Confirm Delete",
//       middleText: "Are you sure you want to delete this Dua?",
//       textConfirm: "Yes, Delete",
//       textCancel: "Cancel",
//       confirmTextColor: Colors.white,
//       onConfirm: () {
//         deleteDua(index);
//         Get.back();
//         Get.snackbar("Deleted", "Dua has been removed", backgroundColor: Colors.red, colorText: Colors.white);
//       },
//       onCancel: () => Get.back(),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';

class DuaController extends GetxController {
  var categories = <DuaCategoryModel>[].obs;
  final String _storageKey = "saved_dua_categories";

  @override
  void onInit() {
    super.onInit();
    loadDuaCategories();
  }

  Future<void> loadDuaCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    if (savedData != null) {
      List<dynamic> decodedList = jsonDecode(savedData);
      categories.assignAll(
          decodedList.map((e) => DuaCategoryModel.fromJson(e)).toList());
    } else {
      // Load default categories with sample duas
      categories.assignAll([
        DuaCategoryModel(name: "Morning Duas", duas: [
          DuaModel(
            title: "صبح کی دعا",
            dua: "اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك المصير",
            translationUrdu: "اے اللہ! تیرے ہی حکم سے ہم نے صبح کی",
            translationEnglish: "O Allah, by You we enter the morning",
            icon: Icons.wb_sunny,
          ),
        ]),
        DuaCategoryModel(name: "Food Duas", duas: [
          DuaModel(
            title: "کھانے سے پہلے کی دعا",
            dua: "اللهم بارك لنا فيما رزقتنا وقنا عذاب النار",
            translationUrdu: "اے اللہ! ہمارے دیے گئے رزق میں برکت عطا فرما",
            translationEnglish: "O Allah, bless us in what You have provided",
            icon: Icons.fastfood,
          ),
        ]),
      ]);
      saveDuaCategories();
    }
  }

  Future<void> saveDuaCategories() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> categoryList =
        categories.map((c) => c.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(categoryList));
  }

  void addDuaToCategory(String categoryName, DuaModel dua) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas.add(dua);
    } else {
      categories.add(
          DuaCategoryModel(name: categoryName, duas: [dua], isUserAdded: true));
    }
    categories.refresh();
    update();
    saveDuaCategories();
  }

  void deleteDua(String categoryName, int index) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas.removeAt(index);
      categories.refresh();
      saveDuaCategories(); // Save changes
    }
  }

  void editDua(String categoryName, int index, DuaModel updatedDua) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas[index] = updatedDua;
      categories.refresh();
      saveDuaCategories(); // Save changes
    }
  }

  void showEditDuaDialog(
      BuildContext context, String categoryName, int index, DuaModel dua) {
    TextEditingController titleController =
        TextEditingController(text: dua.title);
    TextEditingController arabicController =
        TextEditingController(text: dua.dua);
    TextEditingController urduController =
        TextEditingController(text: dua.translationUrdu);
    TextEditingController englishController =
        TextEditingController(text: dua.translationEnglish);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Dua"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: arabicController,
                  decoration: const InputDecoration(labelText: "Arabic Dua"),
                ),
                TextField(
                  controller: urduController,
                  decoration:
                      const InputDecoration(labelText: "Urdu Translation"),
                ),
                TextField(
                  controller: englishController,
                  decoration:
                      const InputDecoration(labelText: "English Translation"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                DuaModel updatedDua = DuaModel(
                  title: titleController.text,
                  dua: arabicController.text,
                  translationUrdu: urduController.text,
                  translationEnglish: englishController.text,
                  icon: dua.icon,
                  isUserAdded: dua.isUserAdded,
                );
                editDua(categoryName, index, updatedDua);
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Dua updated successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Save", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String categoryName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Dua"),
          content: const Text("Are you sure you want to delete this Dua?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteDua(categoryName, index); // Call delete function
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Dua deleted successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showAddDuaDialog(BuildContext context, String categoryName) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController duaController = TextEditingController();
    final TextEditingController translationUrduController =
        TextEditingController();
    final TextEditingController translationEnglishController =
        TextEditingController();

    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "Add New Dua",
      content: Form(
        key: formKey,
        child: Column(
          children: [
            buildTextField(titleController, "Title", true),
            buildTextField(duaController, "Dua in Arabic", true),
            buildTextField(translationUrduController,
                "Translation (Urdu) (optional)", false),
            buildTextField(translationEnglishController,
                "Translation (English) (optional)", false),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addDuaToCategory(
                    categoryName,
                    DuaModel(
                      title: titleController.text,
                      dua: duaController.text,
                      translationUrdu: translationUrduController.text.isEmpty
                          ? ''
                          : translationUrduController.text,
                      translationEnglish:
                          translationEnglishController.text.isEmpty
                              ? ''
                              : translationEnglishController.text,
                      icon: Icons.save,
                      isUserAdded: true,
                    ),
                  );
                  Get.back();
                }
              },
              child: const Text("Add Dua"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hint, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return "$hint is required";
          }
          return null;
        },
      ),
    );
  }

  void showDeleteCategoryDialog(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text(
              "Are you sure you want to delete this category? This will remove all associated Duas."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(categoryName); // Call delete function
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Category deleted successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteCategory(String categoryName) {
    categories.removeWhere((c) => c.name == categoryName);
    categories.refresh(); // Update UI
    saveDuaCategories();
  }

  void showEditCategoryDialog(BuildContext context, String oldCategoryName) {
    TextEditingController categoryController =
        TextEditingController(text: oldCategoryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: "Category Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newCategoryName = categoryController.text.trim();
                if (newCategoryName.isNotEmpty &&
                    newCategoryName != oldCategoryName) {
                  editCategoryName(oldCategoryName, newCategoryName);
                  Navigator.of(context).pop(); // Close dialog
                  Get.snackbar("Success", "Category name updated successfully",
                      snackPosition: SnackPosition.TOP);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void editCategoryName(String oldCategoryName, String newCategoryName) {
    final category =
        categories.firstWhereOrNull((c) => c.name == oldCategoryName);
    if (category != null) {
      category.name = newCategoryName;
      categories.refresh(); // Update UI
      saveDuaCategories();
    }
  }
}
