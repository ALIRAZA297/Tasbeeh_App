import 'package:get/get.dart';

class KalimaController extends GetxController {
  final List<Map<String, String>> kalimas = [
    {
      "title": "1- Kalimah Tayyibah",
      "arabic": "لَا إِلَهَ إِلَّا اللهُ مُحَمَّدٌ رَسُوْلُ اللّٰه",
      "english":
          "There is no god but Allah, and Muhammad is the messenger of Allah.",
      "urdu": "اللہ کے سوا کوئی معبود نہیں، محمد اللہ کے رسول ہیں۔"
    },
    {
      "title": "2- Kalimah Shahadah",
      "arabic":
          "أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ",
      "english":
          "I bear witness that there is no god except Allah; the One alone, without partner, and I bear witness that Muhammad is His Servant and Messenger.",
      "urdu":
          "میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد اس کے بندے اور رسول ہیں۔"
    },
    {
      "title": "3- Kalimah Tamjeed",
      "arabic":
          "سُبْحَانَ اللهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَهُ وَاللهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَا بِاللهِ الْعَلِيِّ الْعَظِيْمِ",
      "english":
          "Exalted is Allah, and praise be to Allah, and there is no deity except Allah, and Allah is the Greatest. And there is no might nor power except in Allah, the Most High, the Most Great.",
      "urdu":
          "اللہ پاک ہے، اور تمام تعریفیں اللہ کے لیے ہیں، اور اللہ کے سوا کوئی معبود نہیں، اور اللہ سب سے بڑا ہے۔ اور کوئی طاقت اور قوت نہیں مگر اللہ کے ساتھ، جو سب سے بلند اور عظیم ہے۔"
    },
    {
      "title": "4- Kalimah Tawheed",
      "arabic":
          "لَا اِلْهَ اِلَّا اللهُ وَحْدَةَ لَا شَرِيْكَ لَهُ لَهُ الْمُلْكُ وَ لَهُ الْحَمْدُ يُجْي وَ يُمِيْتُ وَ هُوَ حَيٌّ لَا يَمُؤْتُ آبَدًا ٱَبَدَأ ذُو الْجَلَالِ وَالْإِكْرَامِ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَى كُلِّ شيْءٍ قَدِيرٌ",
      "english":
          "(There is) no god except Allah - One is He, no partners hath He. His is the Dominion, and His is the Praise. He gives life and causes death, and He is Living, who will not die, never. He of Majesty and Munificence. Within His Hand is (all) good. And He is, upon everything, Able (to exert His Will).",
      "urdu":
          "اللہ کے سوا کوئی معبود نہیں - وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ بادشاہت اسی کی ہے، اور تمام تعریفیں اسی کے لیے ہیں۔ وہ زندگی دیتا ہے اور موت دیتا ہے، اور وہ زندہ ہے، جو کبھی نہیں مرے گا۔ وہ عظمت اور بزرگی والا ہے۔ ہر بھلائی اس کے ہاتھ میں ہے، اور وہ ہر چیز پر قادر ہے۔"
    },
    {
      "title": "5- Kalimah Istighfar",
      "arabic":
          "اسْتَغْفِرُ اللهَ رَبِّيْ مِنْ كُلِّ ذَنْبِ ٱذْنَيْئُةَ عَمَدًا آَوْ خَطَاءٌ سِرًّا آَوْ عَلَانِيَةً وَأَتُوْبُ إِلَيِهِ مِنَ الذَّنْبِ الَّذِيّ اعْلَمٍ وَ مِنَ الذَّتْبِ الَّذِيْ لَا اعْلَمُ إِنَّكَ آَنْتَ عَلَّامُ الْغُيُوْبِ وَ سَتَّارُ الْعُيُوْبِ و غَفَّارُ الذُّنُوْبِ وَ لَا حَوْلَ وَلَا قُوَةَ إِلَّا بِاللهِ الْعَلِيِّ الْعَظِيْمُ",
      "english":
          "I seek forgiveness from Allah, my Lord, from every sin I committed knowingly or unknowingly, secretly or openly, and I turn towards Him from the sin that I know and from the sin that I do not know. Certainly, You (are) the Knower of the hidden things and the Concealer (of) the mistakes and the Forgiver (of) the sins. And (there is) no power and no strength except from Allah, the Most High, the Most Great.",
      "urdu":
          "میں اللہ، اپنے رب سے ہر گناہ کی معافی مانگتا ہوں، جو میں نے جان بوجھ کر یا غلطی سے، خفیہ طور پر یا علانیہ کیا ہو۔ میں اس گناہ سے توبہ کرتا ہوں جسے میں جانتا ہوں اور اس گناہ سے بھی جسے میں نہیں جانتا۔ بے شک، تو ہی پوشیدہ چیزوں کا جاننے والا، عیبوں کو چھپانے والا اور گناہوں کو معاف کرنے والا ہے۔ اور اللہ کے سوا کوئی طاقت اور قوت نہیں، جو سب سے بلند اور عظیم ہے۔"
    },
    {
      "title": "6- Kalimah Radd Kufr",
      "arabic":
          "اللَّهُمَّ إِنِّي آعُوْذُ بِكَ مِنْ آنْ أُشْرِكَ بِكَ شَيْئًا وَانَا آعْلَمُ بِهِ وَ اسْتَغْفِرُكَ لِمَا لَا ٱعْلَمُ بِهِ تُبْتُ عَنْهُ وَ تَبَرَّأْتُ مِنَ الْكُفْرِ وَ الشِّرْكِ وَ الْكِذْبِ وَ الْغِيْبَةِ وَ الْبِدْعَةِ وَ النَّمِيْمَةِ وَ الْفَوَاحِشِ وَ الْبُهْتَانِ وَ الْمَعَاصِىْ كُلِّهَا وَ اسْلَمْتُ وَ ٱَقُوْلُ لَا اِلة اِلَّا اللهُ مُحَمَّدٌ رَسُوْلُ اللَهِ",
      "english":
          "O Allah! I seek protection in You from that I should not join any partner with You and I have knowledge of it. I seek Your forgiveness from that which I do not know. I repent from it (ignorance) and I reject disbelief and joining partners with You and of falsehood and slandering and innovation in religion and tell-tales and evil deeds and the blame and the disobedience, all of them. I submit to Your will and I believe and I declare: There is none worthy of worship except Allah and Muhammad is His Messenger.",
      "urdu":
          "اے اللہ! میں تجھ سے پناہ مانگتا ہوں کہ میں تجھے کسی کو شریک ٹھہراؤں جبکہ مجھے اس کا علم ہو۔ اور میں تجھ سے اس کے بارے میں مغفرت چاہتا ہوں جسے میں نہیں جانتا۔ میں اس سے توبہ کرتا ہوں اور کفر، شرک، جھوٹ، غیبت، بدعت، چغلی، فحاشی، بہتان اور تمام گناہوں سے برأت کا اعلان کرتا ہوں۔ میں تیرا فرمانبردار ہوں اور کہتا ہوں: اللہ کے سوا کوئی معبود نہیں، محمد اس کے رسول ہیں۔"
    }
  ];
}

// UI Code remains the same
