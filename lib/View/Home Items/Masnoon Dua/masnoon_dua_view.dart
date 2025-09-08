import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/masnoon_dua_card.dart';
import 'package:tasbeeh_app/Controller/masnoon_dua_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';

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
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () {
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
              : Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.2,
                      ),
                      Icon(
                        Icons.search_off,
                        size: 50,
                        color: AppColors.grey500,
                      ),
                      Text(
                        'No Dua available',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      floatingActionButton: Obx(
        () {
          final category = duaController.categories
              .firstWhereOrNull((c) => c.name == widget.categoryName);
          return (category != null && category.isUserAdded)
              ? FloatingActionButton(
                  onPressed: () => duaController.showAddDuaDiadebugPrint(
                    context,
                    widget.categoryName,
                  ),
                  backgroundColor: primary,
                  child: const Icon(Icons.add, color: AppColors.white),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
