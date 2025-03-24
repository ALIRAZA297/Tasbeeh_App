import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh_app/Model/count_model.dart';

class CounterController extends GetxController {
  var counterModel = CounterModel().obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    counterModel.value.count = _prefs.getInt('counter') ?? 0;
    update(); // Notify UI
  }

  void increment() {
    counterModel.value.count++;
    _prefs.setInt('counter', counterModel.value.count);
    update();
  }

  void decrement() {
    if (counterModel.value.count > 0) {
      counterModel.value.count--;
      _prefs.setInt('counter', counterModel.value.count);
      update();
    }
  }

  void reset() {
    counterModel.value.count = 0;
    _prefs.setInt('counter', counterModel.value.count);
    update();
  }
}
