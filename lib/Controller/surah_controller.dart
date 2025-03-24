import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurahController extends GetxController {
  var doNotShowAgain = false.obs; // Checkbox state

  @override
  void onInit() {
    super.onInit();
    checkDialogPreference();
  }

  Future<void> checkDialogPreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool shouldShow = prefs.getBool("showSaveAyahDialog") ?? true;

    if (shouldShow) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showSaveAyahDialog();
      });
    }
  }

  Future<void> setDialogPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showSaveAyahDialog", value);
  }

  void showSaveAyahDialog() {
    Get.dialog(
      Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.white,
          colorSchemeSeed: Colors.white,
        ),
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Save Your Reading Progress",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/click.gif",
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "You can save your last read Ayah by clicking on it.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: doNotShowAgain.value,
                      onChanged: (value) {
                        doNotShowAgain.value = value ?? false;
                      },
                    ),
                    Text(
                      "Do not show again",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                minimumSize:
                    MaterialStatePropertyAll(Size(double.infinity, 35)),
                backgroundColor: MaterialStatePropertyAll(Colors.green),
              ),
              onPressed: () {
                if (doNotShowAgain.value) {
                  setDialogPreference(
                      false); // Save preference to not show again
                }
                Get.back(); // Close dialog
              },
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  // Future<void> clearSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear(); // Clears all stored data
  //   log("SharedPreferences cleared!");
  // }
}
