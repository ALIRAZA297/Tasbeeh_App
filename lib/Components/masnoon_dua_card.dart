// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
// import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';

// class DuaCard extends StatelessWidget {
//   final DuaModel dua;
//   final int index;

//   const DuaCard({super.key, required this.dua, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final DuaController duaController = Get.find<DuaController>();

//     return Container(
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.green.shade50,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             /// Title Row with Icon
//             Row(
//               children: [
//                 Icon(dua.icon, color: Colors.green, size: 30),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     dua.title,
//                     textAlign: TextAlign.right,
//                     style: GoogleFonts.notoNastaliqUrdu(
//                       fontSize: 18,
//                       height: 2,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             /// Arabic Dua
//             Text(
//               dua.dua,
//               textAlign: TextAlign.right,
//               style: GoogleFonts.amiriQuran(
//                 fontSize: 24,
//                 height: 2,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),

//             const SizedBox(height: 10),

//             /// Urdu Translation (Only shows if available)
//             if (dua.translationUrdu!.isNotEmpty)
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       "${dua.translationUrdu} ",
//                       textAlign: TextAlign.right,
//                       style: GoogleFonts.notoNastaliqUrdu(
//                         fontSize: 18,
//                         height: 2,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 2,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2.0),
//                     child: Text(
//                       textAlign: TextAlign.right,
//                       "📜",
//                       style: GoogleFonts.notoNastaliqUrdu(
//                         fontSize: 18,
//                         height: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(
//               height: 10,
//             ),

//             /// English Translation (Only shows if available)
//             if (dua.translationEnglish!.isNotEmpty)
//               Text(
//                 "📖 ${dua.translationEnglish}.",
//                 textAlign: TextAlign.left,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   height: 1.5,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ),

//             Row(
//               children: [
//                 if (dua.isUserAdded) ...[
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => duaController.showEditDuaDialog(
//                         context, index, dua),
//                   ),
//                   IconButton(
//                     icon: const Icon(CupertinoIcons.delete, color: Colors.red),
//                     onPressed: () => duaController.showDeleteConfirmationDialog(
//                         context, index),
//                   ),
//                 ],
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';

class DuaCard extends StatelessWidget {
  final DuaModel dua;
  final int index;
  final String category; // ✅ New parameter

  const DuaCard({
    super.key,
    required this.dua,
    required this.index,
    required this.category, // ✅ Receive category
  });

  @override
  Widget build(BuildContext context) {
    final DuaController duaController = Get.find<DuaController>();

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// **Category Name**
            // Text(
            //   "📂 $category", // ✅ Display category name
            //   textAlign: TextAlign.right,
            //   style: GoogleFonts.poppins(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.blueGrey,
            //   ),
            // ),
            // const SizedBox(height: 5),

            /// **Title Row with Icon**
            Row(
              children: [
                Icon(dua.icon, color: Colors.green, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dua.title,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 18,
                      height: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// **Arabic Dua**
            Text(
              dua.dua,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 2,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            /// **Urdu Translation**
            if (dua.translationUrdu.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      dua.translationUrdu,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 18,
                        height: 2,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "📜",
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 18,
                        height: 2,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),

            /// **English Translation**
            if (dua.translationEnglish.isNotEmpty)
              Text(
                "📖 ${dua.translationEnglish}.",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),

            /// **Edit & Delete Buttons** (Only for User-Added Duas)
            if (dua.isUserAdded)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      duaController.showEditDuaDialog(
                          context, category, index, dua);
                    },
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                    onPressed: () {
                      duaController.showDeleteConfirmationDialog(
                          context, category, index);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
