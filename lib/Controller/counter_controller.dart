import 'package:get/get.dart';
import 'package:tasbeeh_app/Model/count_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CounterController extends GetxController {
  var counterModel = CounterModel().obs;
  // late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    counterModel.value.count = 0;
  }

  // Future<void> _loadCounter() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   counterModel.value.count = _prefs.getInt('counter') ?? 0;
  //   update(); // Notify UI
  // }

  void increment() {
    counterModel.value.count++;
    // _prefs.setInt('counter', counterModel.value.count);
    update();
  }

  void decrement() {
    if (counterModel.value.count > 0) {
      counterModel.value.count--;
      // _prefs.setInt('counter', counterModel.value.count);
      update();
    }
  }

  void reset() {
    counterModel.value.count = 0;
    // _prefs.setInt('counter', counterModel.value.count);
    update();
  }


  void launchReviewPage() async {
  const packageName = 'com.tasbeehApp.app';
  final marketUrl = Uri.parse("market://details?id=$packageName");
  final webUrl = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");

  if (await canLaunchUrl(marketUrl)) {
    await launchUrl(marketUrl, mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(webUrl, mode: LaunchMode.externalApplication);
  }
}

}
