import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CounterController extends GetxController {
  SharedPreferences? _prefs;
  var isPrefsInitialized = false.obs;

  /// Store counts per tasbeehId
  var counts = <String, int>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initPrefs();
  }

  Future _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    isPrefsInitialized.value = true;
  }

  Future<int> loadCounter(String tasbeehId) async {
    if (!isPrefsInitialized.value) {
      await _initPrefs();
    }
    final value = _prefs!.getInt('tasbeeh_$tasbeehId') ?? 0;
    counts[tasbeehId] = value;
    update();
    return value;
  }

  Future increment(String tasbeehId) async {
    if (!isPrefsInitialized.value) {
      await _initPrefs();
    }
    counts[tasbeehId] = (counts[tasbeehId] ?? 0) + 1;
    await _prefs!.setInt('tasbeeh_$tasbeehId', counts[tasbeehId]!);
    update();
  }

  Future decrement(String tasbeehId) async {
    if (!isPrefsInitialized.value) {
      await _initPrefs();
    }
    if ((counts[tasbeehId] ?? 0) > 0) {
      counts[tasbeehId] = (counts[tasbeehId]! - 1);
      await _prefs!.setInt('tasbeeh_$tasbeehId', counts[tasbeehId]!);
      update();
    }
  }

  Future reset(String tasbeehId) async {
    if (!isPrefsInitialized.value) {
      await _initPrefs();
    }
    counts[tasbeehId] = 0;
    await _prefs!.setInt('tasbeeh_$tasbeehId', 0);
    update();
  }

  void launchReviewPage() async {
    const packageName = 'com.tasbeehApp.app';
    final marketUrl = Uri.parse("market://details?id=$packageName");
    final webUrl =
        Uri.parse("https://play.google.com/store/apps/details?id=$packageName");

    if (await canLaunchUrl(marketUrl)) {
      await launchUrl(marketUrl, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }
}
