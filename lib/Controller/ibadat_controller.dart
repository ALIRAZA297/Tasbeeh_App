import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class IbadatController extends GetxController {
  final List<Map<String, String>> ibadats = [
    {"title": "Salat ul Tasbeeh", "subtitle": "صلوٰۃ التسبیح"},
    {"title": "Namaz e Janazah", "subtitle": "نماز جنازہ"},
    {"title": "Namaz e Eid", "subtitle": "نماز عید"},
    {"title": "Namaz", "subtitle": "نماز"},
  ];
  List imgPath = [
    "assets/images/salatul tasbeeh.jpg",
    "assets/images/janaza.jpg",
    "assets/images/eid namaz.jpg",
  ];
}
