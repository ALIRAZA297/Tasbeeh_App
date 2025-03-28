import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/masnoon_dua_card.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';

class DuaScreen extends StatefulWidget {
  final String categoryName;

  const DuaScreen({super.key, required this.categoryName});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<DuaController>().loadDuaCategories();
  }

  @override
  Widget build(BuildContext context) {
    final DuaController duaController = Get.find<DuaController>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName,
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
            .firstWhereOrNull((c) => c.name == widget.categoryName);
        return category != null
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: category.duas.length,
                itemBuilder: (context, index) {
                  return DuaCard(
                    dua: category.duas[index],
                    index: index,
                    category: widget.categoryName,
                  );
                },
              )
            : const Center(child: Text("No Duas Available"));
      }),
      floatingActionButton: Obx(
        () {
          final category = duaController.categories
              .firstWhereOrNull((c) => c.name == widget.categoryName);
          return (category != null && category.isUserAdded)
              ? FloatingActionButton(
                  onPressed: () => duaController.showAddDuaDialog(
                    context,
                    widget.categoryName,
                  ),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
