// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Components/masnoon_dua_card.dart';
// import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';

// class DuaScreen extends StatelessWidget {
//   const DuaScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final DuaController duaController = Get.put(DuaController());

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Masnoon Duas",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: Obx(
//         () => Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: duaController.duas.length,
//                 itemBuilder: (context, index) {
//                   return DuaCard(dua: duaController.duas[index], index: index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => duaController.showAddDuaDialog(context),
//         backgroundColor: Colors.green,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/masnoon_dua_card.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';

class DuaScreen extends StatelessWidget {
  final String categoryName;

  const DuaScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final DuaController duaController = Get.find<DuaController>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          categoryName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        final category = duaController.categories
            .firstWhereOrNull((c) => c.name == categoryName);
        return category != null
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: category.duas.length,
                itemBuilder: (context, index) {
                  return DuaCard(
                    dua: category.duas[index],
                    index: index,
                    category: categoryName,
                  );
                },
              )
            : const Center(child: Text("No Duas Available"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => duaController.showAddDuaDialog(
          context,
          categoryName,
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
