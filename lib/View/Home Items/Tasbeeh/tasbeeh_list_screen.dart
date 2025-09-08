import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh_app/Components/animation.dart';
import 'package:tasbeeh_app/Controller/tasbeeh_controller.dart';
import 'package:tasbeeh_app/Utils/app_colors.dart';
import 'package:tasbeeh_app/View/Home%20Items/Tasbeeh/counter_page.dart';

class TasbeehListScreen extends StatelessWidget {
  final bool isMyTasbeeh;
  TasbeehListScreen({super.key, required this.isMyTasbeeh});

  final TasbeehController controller = Get.find<TasbeehController>();
  final ScrollController scrollContext = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Obx(() {
              if (isMyTasbeeh) {
                if (controller.myTasbeehList.isEmpty) {
                  return Align(
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
                          'No Tasbeeh available',
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
                }
                return ListView.builder(
                  controller: scrollContext,
                  shrinkWrap: true,
                  itemCount: controller.myTasbeehList.length,
                  itemBuilder: (context, index) {
                    var tasbeeh = controller.myTasbeehList[index];
                    return _buildTasbeehCard(tasbeeh, index, isMyTasbeeh);
                  },
                );
              } else {
                if (controller.popularTasbeeh.isEmpty) {
                  return const Center(child: Text('No Tasbeeh available'));
                }
                return ListView.builder(
                  controller: scrollContext,
                  shrinkWrap: true,
                  itemCount: controller.popularTasbeeh.length,
                  itemBuilder: (context, index) {
                    var tasbeeh = controller.popularTasbeeh[index];
                    return _buildTasbeehCard(tasbeeh, index, isMyTasbeeh);
                  },
                );
              }
            }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbeehCard(
      Map<String, dynamic> tasbeeh, int index, bool isMyTasbeeh) {
    return GestureDetector(
      onTap: () => Get.to(
        () => CounterPage(
          tasbeeh: tasbeeh,
        ),
      ),
      child: Obx(
        () => AppButtonAnimation(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Text(
                  tasbeeh['title'],
                  textAlign: TextAlign.right,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 18,
                    height: 2,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      tasbeeh['zikr'],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: 26,
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      tasbeeh['translation'],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.notoNastaliqUrdu(
                        height: 2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  if (tasbeeh['count'] != null)
                    Text(
                      'Count: ${tasbeeh['count']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 2,
                        color: AppColors.grey,
                      ),
                    ),
                ],
              ),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isMyTasbeeh ? Icons.edit : CupertinoIcons.add_circled,
                      color: primary,
                    ),
                    onPressed: () {
                      if (isMyTasbeeh) {
                        controller.showTasbeehDiadebugPrint(Get.context!,
                            index: index, tasbeeh: tasbeeh);
                      } else {
                        _showAddTasbeehDiadebugPrint(Get.context!, tasbeeh);
                      }
                    },
                  ),
                  if (isMyTasbeeh)
                    IconButton(
                      icon: const Icon(CupertinoIcons.delete,
                          color: AppColors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Confirm Deletion',
                          content: const Text(
                              'Are you sure you want to delete this tasbeeh?'),
                          textConfirm: 'Delete',
                          textCancel: 'Cancel',
                          confirmTextColor: AppColors.white,
                          onConfirm: () {
                            controller.deleteTasbeeh(index); // Perform deletion
                            Get.back(); // Close the dialog
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTasbeehDiadebugPrint(
      BuildContext context, Map<String, dynamic> tasbeeh) {
    final titleController = TextEditingController(text: tasbeeh['title']);
    final zikrController = TextEditingController(text: tasbeeh['zikr']);
    final translationController =
        TextEditingController(text: tasbeeh['translation']);
    final countController =
        TextEditingController(text: tasbeeh['count']?.toString() ?? '');

    Get.defaultDialog(
      title: 'Add to My Tasbeeh',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: zikrController,
              decoration: const InputDecoration(labelText: 'Zikr'),
            ),
            TextField(
              controller: translationController,
              decoration: const InputDecoration(labelText: 'Translation'),
            ),
            TextField(
              controller: countController,
              decoration: const InputDecoration(
                  labelText: 'Count (optional)', hintText: 'e.g: 33'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
            ),
          ],
        ),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        if (titleController.text.isNotEmpty && zikrController.text.isNotEmpty) {
          final newTasbeeh = {
            'title': titleController.text,
            'zikr': zikrController.text,
            'translation': translationController.text,
            'count': int.tryParse(countController.text), // Nullable int
          };
          controller.myTasbeehList.add(newTasbeeh);
          controller.saveMyTasbeeh();
          Get.back();
        }
      },
    );
  }
}
