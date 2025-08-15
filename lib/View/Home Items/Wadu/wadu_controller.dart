import 'package:get/get.dart';

class WuduController extends GetxController {
  // Reactive list of Wudu steps
  final RxList<Map<String, String>> wuduSteps = [
    {
      'title_en': 'Intention (Niyyah)',
      'title_ur': '۱. نیت',
      'description_en':
          'Make the intention in your heart to perform Wudu for purification.',
      'description_ur': 'دل میں وضو کی نیت کریں کہ یہ طہارت کے لیے ہے۔',
    },
    {
      'title_en': 'Washing Hands',
      'title_ur': '۲. ہاتھ دھونا',
      'description_en':
          'Wash both hands up to the wrists three times, starting with the right hand.',
      'description_ur':
          'دونوں ہاتھوں کو کلائی تک تین بار دھوئیں، دائیں ہاتھ سے شروع کریں۔',
    },
    {
      'title_en': 'Rinsing Mouth',
      'title_ur': 'کلی کرنا',
      'description_en':
          'Take water into your mouth and rinse thoroughly three times.',
      'description_ur': 'پانی منہ میں لیں اور تین بار اچھی طرح کلی کریں۔',
    },
    {
      'title_en': 'Cleaning Nose',
      'title_ur': 'ناک صاف کرنا',
      'description_en':
          'Sniff water into your nostrils and blow it out three times.',
      'description_ur': 'پانی ناک میں لیں اور تین بار ناک صاف کریں۔',
    },
    {
      'title_en': 'Washing Face',
      'title_ur': 'چہرہ دھونا',
      'description_en':
          'Wash the entire face from forehead to chin three times.',
      'description_ur': 'چہرے کو پیشانی سے ٹھوڑی تک تین بار دھوئیں۔',
    },
    {
      'title_en': 'Washing Arms',
      'title_ur': 'بازو دھونا',
      'description_en':
          'Wash both arms from fingertips to elbows three times, starting with the right arm.',
      'description_ur':
          'دونوں بازوؤں کو انگلیوں سے کہنیوں تک تین بار دھوئیں، دائیں بازو سے شروع کریں۔',
    },
    {
      'title_en': 'Wiping Head and Ears',
      'title_ur': 'سر اور کانوں کا مسح',
      'description_en': 'Wipe the head with wet hands and clean the ears once.',
      'description_ur':
          'گیلے ہاتھوں سے سر کا مسح کریں اور ایک بار کان صاف کریں۔',
    },
    {
      'title_en': 'Washing Feet',
      'title_ur': 'پاؤں دھونا',
      'description_en':
          'Wash both feet up to the ankles three times, starting with the right foot.',
      'description_ur':
          'دونوں پاؤں کو ٹخنوں تک تین بار دھوئیں، دائیں پاؤں سے شروع کریں۔',
    },
  ].obs;
}
