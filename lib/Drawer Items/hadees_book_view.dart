import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animated_loader.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Controller/hadees_books_controller.dart';
import 'package:tasbeeh_app/Drawer%20Items/hadees_chapters_view.dart';

class HadithBooksView extends StatelessWidget {
  const HadithBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    final HadithBooksController controller = Get.put(HadithBooksController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hadith Books",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: AnimatedLoader(
                color: Colors.green,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: controller.books.length,
            itemBuilder: (context, index) {
              final book = controller.books[index];
              return AppButtonAnimation(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade700,
                      child: Text(
                        book.id.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      book.bookName,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("By: ${book.writerName}",
                            style: GoogleFonts.poppins(fontSize: 14)),
                        Text(
                            "Chapters: ${book.chaptersCount} | Hadiths: ${book.hadithsCount}",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                    onTap: () => Get.to(
                        () => HadithChaptersView(bookSlug: book.bookSlug)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
