import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehController extends GetxController {
  RxList<Map<String, dynamic>> myTasbeehList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> popularTasbeeh = <Map<String, dynamic>>[
    {
      'title': 'حمد و ثنا اور توبہ و استغفار',
      'zikr': 'سُبْحَانَ اللهِ وَبِحَمدِهِ',
      'translation': 'پاک ہے اللہ اپنی خوبیوں سمیت',
    },
    {
      'title': 'حمد و ثنا اور توبہ و استغفار',
      'zikr': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
      'translation': 'پاک ہے اللہ اپنی خوبیوں سمیت پاک ہے اللہ بہت عظمت والا۔',
    },
    {
      'title': 'توبہ و استغفار',
      'zikr':
          'اسْتَغْفِرُ اللَّهُ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَاتُوبُ اليه',
      'translation':
          'میں اللہ سے معافی مانگتا ہوں، وہ (اللہ) جس کے سوا کوئی معبود نہیں زندہ ہے، کائنات کا نگران ہے اور میں اسی کے حضور توبہ کرتا ہوں۔',
    },
    {
      'title': 'تسبیح فاطمہ',
      'zikr': 'سُبْحَانَ الله 33'
          '\n'
          '33 الحمد لله'
          '\n'
          '33 الله اكبر',
      'translation': 'اللہ پاک ہے، ہر تعریف اللہ کے لیے ہے، اللہ سب سے بڑا ہے۔'
    }
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyTasbeeh();
  }

  Future<void> loadMyTasbeeh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasbeeh = prefs.getStringList('myTasbeeh');
    if (savedTasbeeh != null) {
      myTasbeehList.value = savedTasbeeh
          .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
          .toList();
    }
  }

  Future<void> saveMyTasbeeh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTasbeeh =
        myTasbeehList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('myTasbeeh', encodedTasbeeh);
  }

  void showTasbeehDialog(BuildContext context,
      {int? index, Map<String, dynamic>? tasbeeh}) {
    TextEditingController titleController =
        TextEditingController(text: tasbeeh?['title'] ?? '');
    TextEditingController zikrController =
        TextEditingController(text: tasbeeh?['zikr'] ?? '');
    TextEditingController translationController =
        TextEditingController(text: tasbeeh?['translation'] ?? '');
    TextEditingController countController =
        TextEditingController(text: tasbeeh?['count']?.toString() ?? '');

    Get.defaultDialog(
      title: index == null ? 'Add Tasbeeh' : 'Edit Tasbeeh',
      content: Column(
        children: [
          TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title')),
          TextField(
              controller: zikrController,
              decoration: const InputDecoration(labelText: 'Zikr')),
          TextField(
              controller: translationController,
              decoration: const InputDecoration(labelText: 'Translation')),
          TextField(
            controller: countController,
            decoration: const InputDecoration(
                labelText: 'Count (optional)', hintText: 'e.g: 33'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly, // Allows only digits (no decimal points)
              LengthLimitingTextInputFormatter(
                  5), // Limits input to 5 digits max
            ],
          ),
        ],
      ),
      textConfirm: "Save",
      onConfirm: () {
        if (titleController.text.isNotEmpty && zikrController.text.isNotEmpty) {
          Map<String, dynamic> newTasbeeh = {
            'title': titleController.text,
            'zikr': zikrController.text,
            'translation': translationController.text,
            'count': int.tryParse(countController.text), // Nullable int
          };
          if (index == null) {
            myTasbeehList.add(newTasbeeh);
          } else {
            myTasbeehList[index] = newTasbeeh;
          }
          saveMyTasbeeh();
          Get.back();
        }
      },
      textCancel: "Cancel",
    );
  }

  void deleteTasbeeh(int index) {
    myTasbeehList.removeAt(index);
    saveMyTasbeeh();
  }

  void duplicateTasbeeh(Map<String, dynamic> tasbeeh) {
    myTasbeehList.add({...tasbeeh});
    saveMyTasbeeh();
  }
}
