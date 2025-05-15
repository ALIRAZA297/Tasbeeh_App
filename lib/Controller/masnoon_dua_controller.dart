import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh_app/Model/masnoon_dua_model.dart';

class DuaController extends GetxController {
  var categories = <DuaCategoryModel>[].obs;
  final String _storageKey = "saved_dua_categories";

  @override
  void onInit() {
    super.onInit();
    loadDuaCategories();
  }

  Future<void> loadDuaCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    // Preloaded categories
    List<DuaCategoryModel> preloadedCategories = [
      //________________________ Prayers & Daily Duas _______________________________

      DuaCategoryModel(
        name: "Prayers & Daily Duas",
        duas: [
          DuaModel(
            title: "امتحان کے لیے دعا",
            dua:
                "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي",
            translationUrdu:
                "اے میرے رب! میرا سینہ کھول دے، اور میرا کام آسان فرما، اور میری زبان کی گرہ کھول دے تاکہ لوگ میری بات سمجھ سکیں۔",
            translationEnglish:
                "My Lord, expand for me my chest, and ease my task for me, and untie the knot from my tongue so that they may understand my speech.",
            icon: Icons.edit_document,
          ),
          DuaModel(
            title: "صحت ،خیریت اور عافیت کی دعا",
            dua:
                "اَللّٰھُمَّ اغْفِرْلِیْ وَارْحَمْنِیْ وَاھْدِنِیْ وَعَافِنِیْ وَارْزُقْنِیْ۔",
            translationUrdu:
                "اے اللہ !مجھے ہدایت پر استقامت نصیب فرمااور مجھے رزق عطا فرما اور مجھے معاف فرما اور مجھ پر رحم فرما۔",
            translationEnglish:
                "O Allah, grant me steadfastness in guidance and provide me with sustenance and forgive me and have mercy on me.",
            icon: Icons.health_and_safety_sharp,
          ),
          DuaModel(
            title: "آیت الکرسی",
            dua:
                "ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌۭ وَلَا نَوْمٌۭ ۚ لَّهُۥ مَا فِى ٱلسَّمَـٰوَٰتِ وَمَا فِى ٱلْأَرْضِ ۗ مَن ذَا ٱلَّذِى يَشْفَعُ عِندَهُۥٓ إِلَّا بِإِذْنِهِۦ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَىْءٍۢ مِّنْ عِلْمِهِۦٓ إِلَّا بِمَا شَآءَ ۚ وَسِعَ كُرْسِيُّهُ ٱلسَّمَـٰوَٰتِ وَٱلْأَرْضَ ۖ وَلَا يَـُٔودُهُۥ حِفْظُهُمَا ۚ وَهُوَ ٱلْعَلِىُّ ٱلْعَظِيمُ",
            translationUrdu:
                "اللّٰہ وہ ذات ہے جس کے سوا کوئی معبود نہیں، جو ہمیشہ زندہ اور تمام کائنات کو قائم رکھنے والا ہے۔ اسے نہ اونگھ آتی ہے اور نہ نیند۔ جو کچھ آسمانوں اور زمین میں ہے، سب اسی کی ملکیت ہے۔ کون ہے جو اس کی اجازت کے بغیر اس کے حضور شفاعت کر سکے؟ وہ جانتا ہے جو کچھ ان کے سامنے ہے اور جو کچھ ان کے پیچھے ہے، اور وہ اس کے علم میں سے کسی چیز کا احاطہ نہیں کر سکتے، مگر جتنا وہ چاہے۔ اس کی کرسی آسمانوں اور زمین تک وسیع ہے، اور ان کی حفاظت اسے تھکاتی نہیں، اور وہی سب سے بلند اور سب سے عظمت والا ہے۔",
            translationEnglish:
                "Allah! There is no deity except Him, the Ever-Living, the Sustainer of all existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what is behind them, and they encompass nothing of His knowledge except for what He wills. His Throne extends over the heavens and the earth, and their preservation does not tire Him. And He is the Most High, the Most Great.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "دعائے قنوت",
            dua:
                "اَللَّهُمَّ إنا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنُؤْمِنُ بِكَ وَنَتَوَكَّلُ عَلَيْكَ وَنُثْنِئْ عَلَيْكَ الخَيْرَ وَنَشْكُرُكَ وَلَا نَكْفُرُكَ وَنَخْلَعُ وَنَتْرُكُ مَنْ ئَّفْجُرُكَ اَللَّهُمَّ إِيَّاكَ نَعْبُدُ وَلَكَ نُصَلِّئ وَنَسْجُدُ وَإِلَيْكَ نَسْعأئ وَنَحْفِدُ وَنَرْجُو رَحْمَتَكَ وَنَخْشآئ عَذَابَكَ إِنَّ عَذَابَكَ بِالكُفَّارِ مُلْحَقٌ",
            translationUrdu:
                "اے الله ! ہم تجھ سے مدد مانگتے ہیں اور تجھ سے معافی مانگتے ہیں اور تجھ پر ایمان رکھتے ہیں اور تجھ پر بھروسہ کرتے ہیں اور تیری بہت اچھی تعریف کرتے ہیں اور تیرا شکر کرتے ہیں اور تیری نا شکری نہیں کرتےاور الگ کرتے ہیں اور چھوڑتے ہیں اس شخص کو جو تیری نافرمانی کرے۔ اے الله! ہم تیری ہی عبادت کرتے ہیں اور تیرے ہی لئے نماز پڑھتے ہیں اور سجدہ کرتے ہیں اور تیری ہی طرف دوڑتے اور رجوع کرتے ہیں اور تیری رحمت کے امید وارہیں اور تیرے عذاب سے ڈرتے ہیں، بیشک تیرا عذاب کافروں کو پہنچنے والا ہے",
            translationEnglish:
                "O, Allah! We invoke you for help and beg for forgiveness, and we believe in you and have trust in you and we praise you, in the best way we can; and we thank you and we are not ungrateful to you, and we forsake and turn away from the one who disobeys you. O, Allah! We worship you and prostrate ourselves before you, and we hasten towards you and serve you, and we hope to receive your mercy and we dread your torment. Surely, the disbelievers shall incur your torment.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "شب قدر کی دعا",
            dua: "اَللّٰہُمَّ اِنَّکَ عَفُوّتُحِبُّ الْعَفْوَفَاعْفُ عَنِّیْ ۔",
            translationUrdu:
                "اے اللہ !تو بہت معاف فرمانے والا ہے ،معافی کو پسند فرماتا ہے لہذا مجھے معاف فرمادے۔",
            translationEnglish:
                "O Allah, you are the Most Forgiving, and One who loves forgiving, therefore forgive me",
            icon: Icons.dark_mode,
          ),
          DuaModel(
            title: "مسجد میں داخل ہونے کی دعاء",
            dua: "اَللّٰہُمَّ افْتَحْ لِیْ اَبْوَابَ رَحْمَتِکَ۔",
            translationUrdu:
                "اے اللہ !میرے لئے اپنی رحمت کے دروازے کھول دیجئے۔",
            translationEnglish: "O Allah, open the doors of mercy",
            icon: Icons.login,
          ),
          DuaModel(
            title: "مسجد سے نکلنے کی دعاء",
            dua: "اَللّٰھُمَّ اِنِّیْ اَسْئَلُکَ مِنْ فَضْلِکَ ۔",
            translationUrdu: "اے اللہ !میں آپ کا فضل مانگتا ہوں۔",
            translationEnglish: "O Allah, verily i seek from you, your bounty.",
            icon: Icons.logout,
          ),
          DuaModel(
            title: "وضو ٔ شروع کرنے کی دعا",
            dua: "بِسْمِ اللّٰہِ الرَّحْمٰنِ الرَّحِیْمِ۔",
            translationUrdu:
                "شروع کرتا ہوں اللہ کے نام سے جو بڑا مہربان، نہایت رحم والا ہے ۔",
            translationEnglish:
                "In the name of Allah, the most merciful, the most kind",
            icon: FlutterIslamicIcons.solidWudhu,
          ),
          DuaModel(
            title: "فرض نماز کے بعد کی دعا",
            dua:
                "اَسْتَغْفِرُاللّٰہَ (ثلٰث مرات) اَللّہُمَّ اَنْتَ السَّلَامُ وَمِنْکَ السَّلَامُ تَبَارَکْتَ یَاذَاالْجَلَالِ وَالْاِکْرَامِ ۔",
            translationUrdu:
                "میں اللہ سے معافی مانگتا ہوں (تین مرتبہ کہے) اے اللہ ! تو سلامت رہنے والا ہے اور تجھ سے ہی سلامتی مل سکتی ہے ، تو بابرکت ہے اے بزرگی اور عظمت والے!۔",
            translationEnglish:
                "I seek the forgiveness of Allah (three times) . O Allah, You are Peace and from You comes peace . Blessed are You , O Owner of majesty and honor.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "تہجد کی دعا",
            dua:
                "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلاَ إِلَهَ إِلاَّ اللَّهُ وَاللَّهُ أَكْبَرُ وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ الْعَلِيِّ",
            translationUrdu:
                "اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہت ہے اور اسی کے لیے تمام تعریفیں ہیں، اور وہ ہر چیز پر قدرت رکھنے والا ہے۔ اللہ پاک ہے، تمام تعریفیں اللہ کے لیے ہیں، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے، اور نیکی کی طاقت اور برائی سے بچنے کی قوت صرف اللہ بلند و برتر کے ساتھ ہے۔",
            translationEnglish:
                "There is no god but Allah alone, without any partner. To Him belongs the dominion, and to Him is all praise, and He has power over all things. Glory be to Allah, and all praise is to Allah, and there is no god but Allah, and Allah is the Greatest. There is no power and no strength except with Allah, the Most High, the Most Great.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "التحیات (تشہد) کی دعا",
            dua:
                "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لا إِلَهَ إِلا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
            translationUrdu:
                "تمام زبانی، بدنی اور مالی عبادتیں اللہ کے لیے ہیں، اے نبی! آپ پر سلام ہو، اور اللہ کی رحمت اور برکتیں نازل ہوں، سلام ہم پر اور اللہ کے نیک بندوں پر ہو۔ میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، اور میں گواہی دیتا ہوں کہ محمد ﷺ اللہ کے بندے اور رسول ہیں۔",
            translationEnglish:
                "All greetings, prayers, and good deeds are for Allah. Peace be upon you, O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no god except Allah, and I bear witness that Muhammad is His servant and Messenger.",
            icon: FlutterIslamicIcons.solidTawhid,
          ),
          DuaModel(
            title: "صلوۃالحاجت کی دعا",
            dua:
                "لَا إِلَهَ إِلَّا اللَّهُ الْحَلِيمُ الْكَرِيمُ سُبْحَانَ اللَّهِ رَبِّ الْعَرْشِالْعَظِيمِ، وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ أَسْأَلُكَ مُوجِبَاتِ رَحْمَتِكَ وَعَزَائِمَ مَغْفِرَتِكَ وَالْغَنِيمَةَ مِنْ كُلِّ بِرٍّ وَالسَّلَامَةَ مِنْ كُلِّ إِثْمٍ لَا تَدَعْ لِي ذَنْبَاً إِلَّا غَفَرْتَهُ وَلَا هَمَّاً إِلَّا فَرَّجْتَهُ وَلَا حَاجَةً هِيَ لَكَ رِضَاً إِلَّا قَضَيْتَهَا يَا أَرْحَمَ الرَّاحِمِينَ",
            translationUrdu:
                "اللہ تعالی کے سوا کوئی معبود نہیں جو حلیم و کریم ہے اللہ تعالی کی ذات تمام عیوب سے پاک ہے جو عرش عظیم کا رب ہے تمام تعریفیں اللہ تعالی کیلئے ہیں جو تما م جہانوں کا رب ہے، میں تجھ سے مانگتا ہوں وہ تمام اسباب جو تیری رحمت کیلئے لازم ہوں اور وہ سب اسباب جس سے تیری مغفرت یقینی ہو جائے اور ہر نیکی سے مال غنیمت کی طرح مفت کا حصہ اور ہر گناہ سے سلامتی مانگتا ہوں، کوئی میر ا گناہ باقی نہ چھوڑ جس کو تو بخش نہ دے اور نہ کوئی فکر جس سے تو رہائی نہ دےاور نہ کوئی کڑہن جس کو تو دور نہ فرما دے اور نہ کوئی تکلیف جس کا تو ازالہ نہ فرما دے اور نہ کوئی ایسی ضرورت جو تیری رضا مندی کا سبب ہو جس کو تو پورا نہ فرما دے، اے رحم کرنے والوں میں سب سے بڑھ کر رحم کرنے والے۔",
            translationEnglish:
                "There is none worthy of worship besides Allah, who is the affectionate and most helpful. He is pure and is the Lord of the Arsh (throne). All praise belongs to Allah. O Allah, I desire (seek) that which makes Your mercy compulsory and the things that necessitate Your forgiveness, and portion of every good and safety from every sin. O Merciful of the Merciful, forgive (pardon) my sins and remove all my worries and fullfil all my needs as You desire.",
            icon: FlutterIslamicIcons.solidSajadah,
          ),
          DuaModel(
            title: "واجب غسل کی دعا",
            dua:
                "اللَّهُمَّ اغْسِلْنِيْ مِنَ الذُّنُوْبِ وَطَهِّرْنِيْ مِنَ الْخَطَايَا كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ، اللَّهُمَّ اجْعَلْنِيْ مِنَ التَّوَّابِيْنَ وَاجْعَلْنِيْ مِنَ الْمُتَطَهِّرِيْنَ.",
            translationUrdu:
                "اے اللہ! مجھے گناہوں سے دھو دے اور مجھے خطاؤں سے پاک کر دے، جس طرح سفید کپڑے کو میل کچیل سے پاک کر دیا جاتا ہے۔ اے اللہ! مجھے توبہ کرنے والوں میں سے بنا دے اور مجھے پاکیزگی اختیار کرنے والوں میں شامل فرما۔",
            translationEnglish:
                "O Allah! Wash away my sins and purify me from my mistakes, just as a white garment is cleansed from dirt. O Allah! Make me among those who repent often and make me among those who purify themselves.",
            icon: Icons.shower,
          ),
          DuaModel(
            title: "دعاء ختم القرآن",
            dua:
                "اَللّٰهُمَّ اٰنِسْ وَحْشَتِیْ فِیْ قَبْرِیْ اَللّٰهُمَّ ارْحَمْنِیْ بَالْقُرْاٰنِ الْعَظِیْمِ ؕ وَ اجْعَلْهُ لِیْۤ اِمَامًا وَّ نُوْرًا وَّ هُدًی وَّ رَحْمَةً ؕ اَللّٰهُمَّ ذَكِّرْنِیْ مِنْهُ مَا نَسِیْتُ ؕ وَ عَلِّمْنِیْ مِنْهُ مَا جَهِلْتُ ؕ وَ ارْزُقْنِیْ تِلَاوَتَهٗۤ اٰنَآءَ الَّیلِ وَ اٰنَآءَ النَّهَارِ ؕ وَ اجْعَلْهُ لِیْ حُجَّةً یَّا رَبَّ الْعٰلَمِیْنَ",
            translationUrdu:
                "اے اللہ! میری قبر سے میری وحشت اور پریشانی کو دور فرما، خدایا قرآنِ عظیم کی برکت اور رحمت سے مجھے نواز دے قرآن کو میرے لئے رہنما اور پیشوا بنا اور ساتھ ہی نور اور سببِ ہدایت اور رحمت بنا، الٰہی! اس میں سے جو میں بھول گیا ہوں مجھے یاد دلا دے، اور اس میں سے جو میں نہیں جانتا وہ مجھ کو سِکھا دے اور رات دن مجھے اس کی تلاوت نصیب فرما، اور قیامت کے روز اس کو میرے لئے دلیل بنا اے سارے عالَم کے پرورش کرنے والے۔ آمین",
            translationEnglish:
                "O Allah! Remove the loneliness of my grave. O Allah! Have mercy on me through the Glorious Quran, and make it for me a leader, a light, a guide, and a mercy. O Allah! Remind me of what I have forgotten from it, and teach me what I do not know. Grant me the ability to recite it during the hours of the night and day, and make it a proof in my favor, O Lord of the worlds!",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "سبحانک دعا",
            dua:
                "سُبْحَانَكَ اَللّٰهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالٰى جَدُّكَ (وَجَلَّ ثَنَآئُكَ) وَلاَ اِلٰهَ غَيْرُكَ",
            translationUrdu:
                "اے اللہ! تو پاک ہے اور تیری حمد کے ساتھ، تیرا نام بابرکت ہے، تیری عظمت بلند ہے، (اور تیری تعریف عظیم ہے)، اور تیرے سوا کوئی معبود نہیں۔",
            translationEnglish:
                "Glory be to You, O Allah, and all praise is Yours. Blessed is Your Name, and exalted is Your Majesty. (And glorified is Your praise.) There is no god besides You.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "رزق میں برکت کی دعا",
            dua:
                "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ عَبْدِكَ وَرَسُولِكَ وَعَلَى الْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ وَعَلَى الْمُسْلِمِينَ وَالْمُسْلِمَاتِ",
            translationUrdu:
                "اے اللہ رحمت نازل فرما محمد (صلی اللہ علیہ وسلم) پر جو تیرے بندے اور رسول ہیں اور تمام مومنین مرد و خواتین اور تمام مسلمان مرد و خواتین۔",
            translationEnglish:
                "O Allah, descend mercy on Muhammad (S.A.W.) who is Your servant and Rasul and all the male and female Mo'mins and also all the male and female Muslims",
            icon: Icons.show_chart_rounded,
          ),
          DuaModel(
            title: "ربنا اتنا فی الدنیا حسنہ",
            dua:
                "رَبَّنَا اٰتِنَا فِى الدُّنْيَا حَسَنَةً وَفِى الْٰاخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ رَبَّنَا اغْفِرْلِى وَلِوَالِدَىَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ",
            translationUrdu:
                "اے ہمارے رب! ہمیں دنیا میں بھلائی عطا فرما، اور آخرت میں بھلائی عطا فرما، اور ہمیں آگ کے عذاب سے بچا۔",
            translationEnglish:
                "Our Lord! Grant us good in this world and good in the hereafter, and save us from the chastisement of the fire",
            icon: FlutterIslamicIcons.islam,
          ),
          DuaModel(
            title: "ربنا ھب لنا من ازواجنا",
            dua:
                "رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا",
            translationUrdu:
                "اے ہمارے رب! ہمیں ہماری بیویوں اور اولاد کی طرف سے آنکھوں کی ٹھنڈک عطا فرما، اور ہمیں پرہیزگاروں کا امام بنا دے۔",
            translationEnglish:
                "Our Lord, grant us from among our wives and offspring comfort to our eyes and make us leaders for the righteous.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "نیا چاند دیکھنے کی دعا",
            dua:
                "اَللّٰہُ اَکْبَرُ، اَللّٰہُمَّ اَھِلَّہ عَلَیْنَابِالْیُمْنِ وَالْاِیْمَانِ وَالسَّلَامَةِ وَالْاِسْلَامِ ،رَبِّیْ وَرَبُّکَ اللّٰہُ ۔",
            translationUrdu:
                "اللہ بہت بڑا ہے ،یااللہ! اس چاند کو ہم پر برکت ، ایمان ، سلامتی اور اسلام کے ساتھ نکالنا ،(اے چاند) میرااور تیرا رب اللہ ہے ۔",
            translationEnglish:
                "O Allah Azzawajal make this moon come out on us with blessings and with Iman and peace and Islam and make it come out with the ability of that thing which pleases you and that you like, (O moon of the first night my and your Lord is Allah Azzawajal).",
            icon: Icons.dark_mode_rounded,
          ),
          DuaModel(
            title: "حضرت یونس علیہ السلام کی دعا",
            dua:
                "لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
            translationUrdu:
                "اے اللہ! تیرے سوا کوئی معبود نہیں، تو پاک ہے، بے شک میں ہی ظالموں میں سے ہوں۔",
            translationEnglish:
                "There is no Allah but you; you are glorified. Indeed, I am from wrongdoers.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "ناپسندیدہ چیز دیکھتے وقت کی دعا",
            dua: "اَلْحَمْدُ لِلّٰہِ عَلٰی کُلِّ حَال۔",
            translationUrdu: "ہر حال میں اللہ کاشکر ہے ۔",
            translationEnglish:
                "Allah is deserving (worthy) of praise under all circumstances.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "نیند میں ڈرجائے یا برا خواب دیکھنے کے بعد کی دعا",
            dua:
                "اَعُوْذُبِکَلِمَاتِ اللہِ التَّآمَّۃِ مِنْ غَضَبِہ وَعِقَابِہ وَمِنْ شَرِّ عِبَادِہ وَمِنْ ھَمَزَاتِ الشَّیَاطِیْنِ وَاَنْ یَّحْضُرُوْنِ۔",
            translationUrdu:
                "میں اللہ تعالیٰ کی پکی باتوں کی پناہ پکڑتا ہوں اس کے غصہ، اس کے عذاب اور اس کی مخلوق کے شر سے اور شیطانوں کی چھیڑسے اور اس سے کہ وہ میرے قریب آئیں ۔",
            translationEnglish:
                "i seek refuge in the perfect words of Allah from his anger and from his punishment, from the evil of his slaves and from the taunts of devils and from their presence.",
            icon: Icons.hotel,
          ),
          DuaModel(
            title: "میزبان کے گھر سے رخصت ہونے کی دعا",
            dua:
                "اَللّٰھُمَّ بَارِکْ لَھُمْ فِیمَارَزَقْتَھُمْ وَاغْفِرْلَھُمْ وَارْحَمْھُمْ ۔",
            translationUrdu:
                "یااللہ ! ان کے رزق میں برکت عطا فرما، ان کی مغفرت کر اور ان پر رحم فرما۔",
            translationEnglish:
                "O Allah, bless for them, that which You have provided them, forgive them and have mercy upon them.",
            icon: Icons.logout,
          ),
          DuaModel(
            title: "دعاءِ کفارۂ مجلس",
            dua:
                "سُبْحـَانَكَ اللَّهُـمَّ وَبِحَمْدِكَ، أَشْهَـدُ أَنْ لاَ إِلَهَ إِلاَّ أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَـيْكَ",
            translationUrdu:
                "اے اللہ! تو پاک ہے اور تیری حمد کے ساتھ، میں گواہی دیتا ہوں کہ تیرے سوا کوئی معبود نہیں، میں تجھ سے بخشش مانگتا ہوں اور تیری طرف توبہ کرتا ہوں۔",
            translationEnglish:
                "Glory is to You, O Allah, and praise is Yours. I bear witness that there is no god but You. I seek Your forgiveness and turn to You in repentance.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "رزق حلال کمانے کی دعا",
            dua:
                "اَللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا , وَ رِزْقًا طَيَّبًا , وَ عَمَلاً مُتَقَبَّلاً",
            translationUrdu:
                "اے اللہ! میں تجھ سے نفع بخش علم، پاکیزہ رزق اورقبول ہونے والے عمل کا سوال کرتا ہوں۔",
            translationEnglish:
                "O Allah! I ask You for beneficial knowledge, pure and lawful sustenance, and accepted deeds.",
            icon: Icons.fastfood_sharp,
          ),
          DuaModel(
            title: "نوکری حاصل کرنے کی دعا",
            dua:
                "اللّهُمَّ لا سَهْلَ إلا ما جَعَلْتَهُ سَهْلا وَأنتَ تَجْعَلُ الحَزْنَ إذا شِئْتَ سَهْلا",
            translationUrdu:
                "اے اللہ! کوئی کام آسان نہیں مگر جسے تو آسان بنا دے، اور اگر تو چاہے تو مشکل کو بھی آسان بنا دے۔",
            translationEnglish:
                "O Allah! There is no ease except what You make easy. And if You will, You can make the difficult easy.",
            icon: Icons.work,
          ),
          DuaModel(
            title: "مجلس سے اٹھنے کی دعا",
            dua:
                "سُبْحَانَکَ اللّٰھُمَّ وَبِحَمْدِکَ اَشْہَدُاَلَّااِلٰہَ اِلَّااَنْتَ اَسْتَغْفِرُکَ وَاَتُوْبُ اِلَیْکَ ۔",
            translationUrdu:
                "اے اللہ !تو پاک ہے اور تیری ہی تعریف ہے ،گواہی دیتا ہوں کہ تیرے سواکوئی معبود نہیں ،آ پ سے مغفرت چاہتا ہوںاورتوبہ کرتا ہوں۔",
            translationEnglish:
                "O Allah, You are pure, I praise You and testify that there is none worthy of worship besides You. I seek forgiveness and pardon from You. If there was good talk in the gathering, this dua will seal it and if there was futile and vain talk, then this dua will recompense for it.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "ایمان مفصل",
            dua:
                "آمَنْتُ بِاللّٰهِ وَمَلٰائِكَتِهٖ وَكُتُبِهٖ وَرُسُلِهٖ وَالْيَوْمِ الْاٰخِرِ وَبِالْقَدَرِ خَيْرِهٖ وَشَرِّهٖ مِنَ اللّٰهِ تَعٰالٰى وَالْبَعْثُ بَعْدَ الْمَوْتِ حَقٌّ اَشْهَدُ اَنْ لٰا اِلٰهَ اِلَّا اللّٰهُ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
            translationUrdu:
                "میں ایمان لایا اللہ پر، اس کے فرشتوں پر، اس کی کتابوں پر، اس کے رسولوں پر، اور آخرت کے دن پر، اور تقدیر پر، اس کی بھلائی اور برائی پر، جو کہ اللہ تعالیٰ کی طرف سے ہے، اور مرنے کے بعد دوبارہ زندہ کیے جانے پر جو کہ برحق ہے۔ میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔",
            translationEnglish:
                "I believe in Allah, His angels, His books, His messengers, the Last Day, and in destiny—both its good and its bad—from Allah the Almighty. And (I believe) in resurrection after death, which is true. I bear witness that there is no god except Allah, and I bear witness that Muhammad is His servant and Messenger.",
            icon: FlutterIslamicIcons.islam,
          ),
          DuaModel(
            title: "استخارہ کی دعا",
            dua:
                "اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَتَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَّامُ الْغُيُوبِ اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ شَرٌّ فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ ارْضِنِي بِهِ",
            translationUrdu:
                "اے اللہ! بے شک میں تجھ سے تیرے علم کے ساتھ بھلائی طلب کرتا ہوں اور تجھ سے تیری قدرت کے ساتھ طاقت طلب کرتا ہوں اور میں تجھ سے تیرے فضل عظیم کا سوال کرتا ہوں کیونکہ تو قدرت رکھتا ہے اور میں قدرت نہیں رکھتا ، تو جانتا ہے اور میں نہہیں جانتا اور تو غیبوں کو خوب جانتا ہے۔ اے اللہ اگر تو جانتا ہے کہ بے شک یہ کا م (اس کام کا نام لے) میرے لئے میرے دین ، میرے معاش اور میرے انجا م کار کے لحاظ سے بہتر ہے تو اس کا میرے حق میں فیصلہ کر دے اور اسے میرے لئے آسان کر دے ، پھر میرے لئے اس میں برکت ڈال دے اور اگر تو جانتا ہے کہ بے شک یہ کام (اس کام کا نام لے) میرے لئے میرے دین، میرے معاش اور میرے انجام کارکے لحاظ سے برا ہے تو اسے مجھ سے دور کر دے اور مجھے اس سے دور کر دے اور میرے لئے بھلائی کا فیصلہ کر دے جہاں بھی وہ ہو ، پھر مجھے اس پر راضی کر دے ۔",
            translationEnglish:
                "O Allah, with Your knowledge I seek the good, with Your power I seek ability and Your mighty favour for certainly You have the power that I don't have, You know and I do not Know and You Know the unseen. O Allah, in Your knowledge if this work is good for me in this Duniya and the Akhirah (hereafter), then let it be for me, grant me blessings in it and if it is bad for me then keep it far away from me and grant me any destiny that will make me happy",
            icon: FlutterIslamicIcons.islam,
          ),
          DuaModel(
            title: "استغفارکی دعا",
            dua: "أسْتَغْفِرُ اللهَ رَبي مِنْ كُلِ ذَنبٍ وَأتُوبُ إلَيهِ",
            translationUrdu:
                "میں اللہ سے اپنے ہر گناہ کی معافی مانگتا ہوں اور اسی کی طرف رجوع کرتا ہوں",
            translationEnglish:
                "I seek forgiveness from Allah for all my sins and turn to Him in repentance",
            icon: FlutterIslamicIcons.solidTasbihHand,
          ),
          DuaModel(
            title: "کوئی چیز گم ہ جانے کے بعد کی دعا",
            dua:
                "اللَّهُمَّ رَادَّ الضَّالَّةِ وَهَادِي الضَّالَّةِ أَنْتَ تَهْدِي مِنَ الضَّلَالَةِ ارْدُدْ عَلَيَّ ضَالَّتِي بِقُدْرَتِكَ وَسُلْطَانِكَ فَإِنَّهَا مِنْ عَطَائِكَ وَفَضْلِكَ",
            translationUrdu:
                "اے اللہ جو کھویا ہوا لوٹا دیتا ہے، اپنی قدرت اور خوف سے جو میں نے کھویا ہے اسے واپس کر، یقیناً میں نے یہ تیرا تحفہ اور احسان کے طور پر حاصل کیا ہے۔",
            translationEnglish:
                "O Allah, the One who returns the lost, by Your power and awe return what I have lost, for surely I have received it as Your gift and favour (boon)",
            icon: FlutterIslamicIcons.solidAllah,
          ),
          DuaModel(
            title: "اداء قرض میں آسانی کی دعا",
            dua:
                "اَللّٰہُمَّ اَکْفِنِیْ بِحَلَالِکَ عَنْ حَرَامِکَ وَاَغْنِنِیْ بِفَضْلِکَ عَمَّنْ سِوَاکَ ۔",
            translationUrdu:
                "اے اللہ ! اپنے حلال کے ذریعے مجھے حرام سے بچا اورمجھے اپنے فضل سے اپنے ماسواسے مستغنی فرمادے۔",
            translationEnglish:
                "may Allah almighty give me enough, give me your Halal provision and save me from Haraam provision and do not make me needy of anyone except yourself by your grace.",
            icon: Icons.money,
          ),
          DuaModel(
            title: "برے خیالات آتے وقت کی دعا",
            dua:
                "اللَّهُمَّ لَا يَأْتِي بِالْحَسَنَاتِ إِلَّا أَنْتَ وَلَا يَذْهَبُ بِالسَّيِّئَاتِإِلَّا أَنْتَ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِكَ",
            translationUrdu:
                "اے اللہ تو ہی بھلائی کو وجود میں لاتا ہے اور ہر برائی کو تو ہی دور کر سکتا ہے کیونکہ نیکی کرنے اور برائی سے روکنے کی طاقت تیرے اختیار میں ہے۔",
            translationEnglish:
                "O Allah, you bring into existence the good and only you can remove any bad condition, as the power to do good and prevent from evil is in Your control",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "دعائے ماثورہ",
            dua:
                "اَللّٰھُمَّ أِنِّیْ ظَلَمْتُ نَفْسِیْ ظُلْمًا کَثِیْرًا وَّلَا یَغْفِرُ الذُّنُوْبَ اِلَّا أَنْتَ فَاغْفِرْلِیْ مَغْفِرَةً مِّنْ عِنْدِكَ وَارْحَمْنِیْ أِنَّكَ أَنْتَ الْغَفُوْرُ الرَّحِیْمَ",
            translationUrdu:
                "’اے اللہ! میں نے اپنے نفس پر بہت ظلم کیا ہے اور تیرے سوا کوئی بخشنے والا نہیں، میری مغفرت فرما اور مجھ پر رحم فرما، بلاشبہہ تو بخشنے اور رحم کرنے والا ہے۔",
            translationEnglish:
                "O Allah! Indeed, I have wronged myself with great injustice, and none forgives sins except You. So forgive me with Your forgiveness and have mercy on me. Indeed, You are the Most Forgiving, the Most Merciful.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
        ],
      ),

      //________________________ Morning & Evening _______________________________

      DuaCategoryModel(name: "Morning & Evening", duas: [
        DuaModel(
          title: "صبح بیدار ہونے کی دعا",
          dua:
              "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
          translationUrdu:
              "تمام تعریفیں اللہ کے لیے ہیں، جس نے ہمیں موت (نیند) کے بعد زندگی عطا فرمائی، اور اسی کی طرف لوٹ کر جانا ہے۔",
          translationEnglish:
              "All praise is for Allah who has given us life after causing us to die, and to Him is the resurrection.",
          icon: Icons.wb_twighlight,
        ),
        DuaModel(
          title: "2 جاگنے کی دعا",
          dua:
              "اَلْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي، وَرَدَّ عَلَيَّ رُوحِي، وَأَذِنَ لِي بِذِكْرِهِ",
          translationUrdu:
              "تمام تعریفیں اس اللہ کے لیے ہیں جس نے میرے جسم کو عافیت دی، میری روح لوٹائی، اور مجھے اپنے ذکر کی اجازت دی",
          translationEnglish:
              "All praise is for Allah, who granted me well-being in my body, restored my soul, and allowed me to remember Him.",
          icon: Icons.fastfood,
        ),
        DuaModel(
          title: "3 صبح کی دعا",
          dua:
              "اَصْبَحْنَا وَاَصْبَحَ الْمُلْکُ لِلّٰہِ رَبِّ الْعَالَمِیْنَ اَللّٰھُمَّ اِنِّیْ اَسْاَلُکَ خَیْرَ ھٰذَاالْیَومِ وَفَتْحَہ وَنَصْرَہ وَنُوْرَہ وَبَرَ کَتَہ وَھُدَاہُ وَاَعُوْذُبِکَ مِنْ شَرِّ مَافِیْہِ وَشَرِّ مَابَعْدَہ۔",
          translationUrdu:
              "ہم نے اللہ کے ملک میں صبح کی جوتمام جہانوں کا رب ہے، اے اللہ! میں آپ سے سؤال کرتا ہوں اس دن کی بھلائی کا ، فتح ونصرت،نوروبرکت اور ہدایت کا ،اور اس دن کے بعد کی برائیوں سے پناہ مانگتا ہوں۔",
          translationEnglish:
              "We have entered a new day and with it all the dominion which belongs to Allah, Lord of all that exists. O Allah, I ask You for the goodness of this day, its victory, its help, its light, its blessings, and its guidance. I seek refuge in You from the evil that is in it and from the evil that follows it.",
          icon: Icons.wb_sunny_sharp,
        ),
        DuaModel(
          title: "سوتے وقت کی دعا",
          dua: "اَللّٰھُمَّ بِاسْمِکَ اَمُوْتُ وَاَحْیٰی۔",
          translationUrdu: "اے اللہ ! میں تیرا نام لے کر مرتا اور جیتا ہوں۔",
          translationEnglish: "O Allah (Almighty) I live and die in your name.",
          icon: Icons.hotel,
        ),
        DuaModel(
          title: "شام کی دعا",
          dua:
              "اَمْسَیْنَاوَاَمْسَی الْمُلْکُ لِلّٰہِ رَبِّ الْعَالَمِیْنَ اَللّٰہُمَّ اِنِّیْ اَسْئَلُکَ خَیْرَ ھَذِہِ اللَّیْلَةِ وَفَتْحَھَاوَنَصْرَھَا وَنُوْرَھَا وَبَرَکَتَہَا وَھُدَاھَاوَاَعُوْذُ بِکَ مِنْ شَرِّ مَافِیْھَا وَشَرِّ مَابَعْدَھَا۔",
          translationUrdu:
              "ہم نے اللہ کے ملک میں شام کی ،اے اللہ !میں آپ سے اس رات کی بھلائی کا ،فتح و نصرت ،نوروبرکت اور ہدایت کا سؤال کرتا ہوں ،اور اس رات کی برائی اور اس کے بعد کی برائیوں سے پناہ مانگتا ہوں ۔",
          translationEnglish:
              "The evening has come to me and the whole universe belongs to Allah who is The Lord of the worlds. O Allah, I ask of you the good of the night, it's success and aid and its nur (celestial light) and barakaat (blessings) and seek hidayat (guidance) and refuge from the evil of this night and the evil that is to come later.",
          icon: Icons.brightness_7_rounded,
        ),
        DuaModel(
          title: "آئنہ دیکھتے وقت کی دعا",
          dua: "اللَّهُمَّ أَنْتَ حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي",
          translationUrdu:
              "اللہ عزوجل تو نے میری صورت اچھی بنائی تو میری سیرت (اخلاق) بھی اچھی کردے۔",
          translationEnglish:
              "O Allah Azzawajal as you made my outward appearance good make my character good too.",
          icon: Icons.assignment_ind,
        ),
      ]),

      //________________________ Food & Drinks _______________________________

      DuaCategoryModel(
        name: "Food & Drinks",
        duas: [
          DuaModel(
            title: "کھاناشروع کرنے کی دعاء",
            dua: "بِسْمِ اللّٰہِ الرَّحْمٰنِ الرَّحِیْمِ۔",
            translationUrdu:
                "شروع کرتا ہوں اللہ کے نام سے جو بڑا مہربان، نہایت رحم والا ہے۔",
            translationEnglish:
                "In the name of Allah, the most merciful, the most kind",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "2 کھانے سے پہلے کی دعا",
            dua: "بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ",
            translationUrdu:
                "میں نے الله کے نام کے ساتھ اور الله کی برکت پر کھانا شروع کیا",
            translationEnglish:
                "In the name of Allah and with the blessings of Allah I begin (eating)",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "کھانے کے بعد کی دعا",
            dua:
                "الْحَمْـدُ للهِ الَّذي أَطْعَمَنـي هـذا وَرَزَقَنـيهِ مِنْ غَـيْرِ حَوْلٍ مِنِّي وَلا قُوَّة",
            translationUrdu:
                "تمام تعریفیں اللہ کے لیے ہیں جس نے مجھے یہ کھانا کھلایا اور مجھے رزق دیا، بغیر کسی طاقت اور قوت کے جو میرے پاس ہو",
            translationEnglish:
                "All praise is for Allah, Who has fed me this food and provided it for me, without any power or might on my part.",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "2 کھانے کے بعد کی دعا ",
            dua:
                "اَلْحَمْدُ لِلّٰہِ الَّذِیْ اَطْعَمَنَا وَسَقَانَاوَجَعَلَنَامُسْلِمِیْنَ ۔",
            translationUrdu:
                "شکر ہے اللہ کا جس نے ہم کو کھلایا اورپلایا اور ہمیں مسلمان بنایا۔",
            translationEnglish:
                "Thanks to Allah Azzawajal who fed us and made us among Muslims",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "دعوت کھانے کے بعد کی دعا",
            dua:
                "اَللّٰھُمَّ اَطْعِمْ مَنْ اَطْعَمَنِیْ وَاسْقِ مَنْ سَقَانِیْ۔",
            translationUrdu:
                "یااللہ ! کھلا اس کو جس نے مجھے کھلایا اور پلااس کو جس نے مجھے پلایا۔",
            translationEnglish:
                "O Allah Azzawajal feed him who fed me and give him to drink who gave to drink.",
            icon: Icons.food_bank_rounded,
          ),
          DuaModel(
            title: "کھانے کے شروع میں بسم اللہ پڑھنا بھول جائے",
            dua: "بِسْمِ اللّٰہِ اَوَّلَہ وَاٰخِرَہ۔",
            translationUrdu: "اول وآخر اللہ تعالیٰ کے نام ہی سے شروع کرتا ہوں۔",
            translationEnglish:
                "Allah Azzawajal in the name of before and after it.",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "دودھ پینے کے بعدکی دعاء",
            dua: "اَللّٰھُمَّ بَارِکْ لَنَافِیْہِ وَزِدْنَامِنْہُ۔",
            translationUrdu:
                "اے اللہ !اس میں ہمارے لئے برکت عطا فرما اوراس سے زیادہ عطا فرما۔",
            translationEnglish:
                "O Allah Azzawajal give us abundance in this and grant us more then this.",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "آب زم زم پیتے وقت کی دعا",
            dua:
                "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمَاً نَافِعَاًً وَرِزْقَاً وَاسِعَاًَ وَشِفَاءً مِنْ كُلِّ دَاءٍ",
            translationUrdu:
                "الٰہی عزوجل میں تجھ سے علم نافع کا اور رزق کی کشادگی کا اور بیماری سے شفایابی کا سوال کرتا ہوں۔",
            translationEnglish:
                "Allah Azzawajal I ask you for beneficial knowledge, increase in provision and cure from illness.",
            icon: Icons.water_drop_rounded,
          ),
        ],
      ),

      //________________________ Dressing _______________________________

      DuaCategoryModel(
        name: "Dressing",
        duas: [
          DuaModel(
            title: "جب نیا لباس پہنے تو یہ دعامانگے",
            dua:
                "اَلْحَمْدُ لِلّٰہِ الَّذِیْ کَسَانِیْ مَآاُوَارِیْ بِہ عَوْرَتِیْ وَاَتَجَمَّلُ بِہ فِیْ حَیَاتِیْ ۔",
            translationUrdu:
                "شکر ہے اللہ کا جس نے مجھ کو ایسا لباس پہنایا کہ میں اس سے اپنا سترڈھانپتا ہوں اور زینت کرتا ہوں اس سے اپنی زندگی میں۔",
            translationEnglish:
                "All praise belongs to Allah who adorned me with clothing by which I cover (hide) my private areas and by which I obtain beauty in my life.",
            icon: Icons.dry_cleaning,
          ),
        ],
      ),

      //________________________ Roza _______________________________

      DuaCategoryModel(
        name: "Roza",
        duas: [
          DuaModel(
            title: "رمضان کی دعا",
            dua:
                "اللَّهُمَّ ارْحَمْنِي بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِينَ",
            translationUrdu:
                "اے اللہ! اپنی رحمت کے ساتھ مجھ پر رحم فرما، اے سب رحم کرنے والوں میں سب سے زیادہ رحم کرنے والے!",
            translationEnglish:
                "O Allah, have mercy on me with Your mercy, O Most Merciful of those who show mercy!",
            icon: FlutterIslamicIcons.solidLantern,
          ),
          DuaModel(
            title: "روزہ رکھنے کی نیت",
            dua: "وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانَ.",
            translationUrdu: "اورمیں نے ماہ رمضان کے کل کے روزے کی نیت کی",
            translationEnglish:
                "I Intend to keep the fast for month of Ramadan",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "روزہ افطار کرتے وقت کی دعا",
            dua: "اَللّٰھُمَّ لَکَ صُمْتُ وَعَلٰی رِزْقِکَ اَفْطَرْتُ ۔",
            translationUrdu:
                "اے اللہ !میں نے تیری رضا کے لئے روزہ رکھا اور تیرے ہی رزق پر افطار کیا ۔",
            translationEnglish:
                "O Allah! I fasted for you and i believe in you [and i put my trust in you] and i break my fast with your sustenance.",
            icon: FlutterIslamicIcons.solidIftar,
          ),
          DuaModel(
            title: "افطارکرنے کے بعد کی دعا",
            dua:
                "ذَھَبَ الظَّمَأُوَابْتَلَّتِ الْعُرُوْقُ وَثَبَتَ الْاَجْرُ اِنْ شَآئَ اللّٰہُ۔",
            translationUrdu:
                "پیاس جاتی رہی اور رگیں تر ہوگئیں اور ثواب ثابت ہوگیا ان شاء اللہ تعالیٰ۔",
            translationEnglish:
                "Thirst has gone, the veins are moist, and the reward is assured, if Allah wills.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "کسی کے ہاں روزہ افطار کرے تو یہ دعاپڑھے",
            dua:
                "اَفْطَرَعِنْدَ کُمُ الصَّآئِمُوْنَ وَاَکَلَ طَعَامَکُمُ الْابَرَارُ وَصَلَّتْ عَلَیْکُمُ الْمَلَآئِکَةُ ۔",
            translationUrdu:
                "افطارکیا کریں تمہارے یہاں روزہ دار لوگ اور کھایا کریں تمہارا کھانا نیک لوگ اور رحمت کی دعا کیا کریں تمہارے لئے فرشتے ۔",
            translationEnglish:
                "May the fasting (people) break their fast in your home, and may the dutiful and pious eat your food, and may the angels send prayers upon you.",
            icon: Icons.food_bank_rounded,
          ),
          DuaModel(
            title: "تراویح کی دعا",
            dua:
                "سُبْحَانَ ذِی الْمُلْکِ وَالْمَلَکُوْتِ ط سُبْحَانَ ذِی الْعِزَّةِ وَالْعَظَمَةِ وَالْهَيْبَةِ وَالْقُدْرَةِ وَالْکِبْرِيَآئِ وَالْجَبَرُوْتِ ط سُبْحَانَ الْمَلِکِ الْحَيِ الَّذِی لَا يَنَامُ وَلَا يَمُوْتُ سُبُّوحٌ قُدُّوْسٌ رَبُّنَا وَرَبُّ الْمَلَائِکَةِ وَالرُّوْحِ ط اَللّٰهُمَّ اَجِرْنَا مِنَ النَّارِ يَا مُجِيْرُ يَا مُجِيْرُ يَا مُجِيْر",
            translationUrdu:
                "پاک ہے (وہ اﷲ) زمین و آسمان کی بادشاہی والا۔ پاک ہے (وہ اﷲ) عزت و بزرگی، ہیبت و قدرت اور عظمت و رُعب والا۔ پاک ہے بادشاہ (حقیقی، جو) زندہ ہے، سوتا نہیں اور نہ مرے گا۔ بہت ہی پاک (اور) بہت ہی مقدس ہے ہمارا پروردگار اور فرشتوں اور روح کا پروردگار۔ اِلٰہی ہم کو دوزخ سے پناہ دے۔ اے پناہ دینے والے! اے پناہ دینے والے! اے پناہ دینے والے!",
            translationEnglish:
                "Exalted is the Possessor of the hidden and the manifest dominion. Exalted is the Possessor of Might, Greatness, Reverence, Power, Pride, and Majesty. Exalted is the Master, the Living, the one who neither sleeps nor dies. All-perfect, All-holy, Our Lord, and the Lord of the angels and the souls. O Allah, grant us refuge from the Hellfire. O Granter of refuge, O Granter of refuge, O Granter of refuge.",
            icon: FlutterIslamicIcons.solidSajadah,
          ),
        ],
      ),

      //________________________ Sickness _______________________________

      DuaCategoryModel(
        name: "Sickness",
        duas: [
          DuaModel(
            title: "شفا کے لیے دعا",
            dua:
                "اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ وَاشْفِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءٌ لَا يُغَادِرُ سَقَمَا",
            translationUrdu:
                "اے اللہ! لوگوں کے رب! تکلیف کو دور فرما، شفا عطا فرما، تو ہی شفا دینے والا ہے، تیرے سوا کوئی شفا نہیں دے سکتا، ایسی شفا دے جو کسی بیماری کو باقی نہ چھوڑے۔",
            translationEnglish:
                "O Allah, the Lord of mankind, remove the difficulty and bring about healing as you are the healer. There is no healing except your healing, a healing that will leave no ailment.",
            icon: Icons.health_and_safety_sharp,
          ),
          DuaModel(
            title: "کسی مصیبت زدہ یافاسق کو دیکھے تو یہ دعاء پڑھے",
            dua:
                "اَلْحَمْدُ لِلّٰہِ الَّذِیْ عَافَانِیْ مِمَّاابْتَلاَ کَ بِہ وَفَضَّلَنِیْ عَلٰی کَثِیْرٍ مِّمَّنْ خَلَقَ تَفْضِیْلاً۔",
            translationUrdu:
                "تمام تعریفیں اس اللہ تعالیٰ کی ہیں جس نے بچایا مجھے اس مصیبت سے جس میں تجھے مبتلا کیا اور مجھے اپنی مخلوق میں سے بہت ساروں پر فضیلت دی ۔",
            translationEnglish:
                "All praise belongs to Allah who has saved me from such a condition which is afflicted on you and favoured me over many creations. The virtues of this dua is that the reciter will be saved from the difficulties he has seen.",
            icon: Icons.sentiment_very_dissatisfied_rounded,
          ),
          DuaModel(
            title: "جلنے کے بعد کی دعا",
            dua:
                "أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ اشْفِ أَنْتَ الشَّافِي لَا شَافِيَ إِلَّا أَنْتَ",
            translationUrdu:
                "اے اللہ! تو تمام لوگوں کا رب ہے، بیماری کو دور کر دے اور اسے شفا عطا فرما، تو ہی شفا دینے والا ہے، تیر ی شفاع کے علاوہ اور کوئی شفاع نہیں۔",
            translationEnglish:
                "O Lord of all mankind, remove the difficulty and grant relief (for) there is no One but You who grants relief (cure)",
            icon: Icons.fireplace_rounded,
          ),
          DuaModel(
            title: "درد اور بخار کی دعا",
            dua:
                "بِسْمِ اللَّهِ الْكَبِيرِ أَعُوذُ بِاللَّهِ الْعَظِيمِ مِنْ شَرِّ كُلِّ عَرَقٍ نَعَّارٍ وَمِنْ شَرِّ حَرِّ النَّارِ",
            translationUrdu:
                "شروع اللہ کے نام سے جو کبریائی والا ہے اور میں اس اللہ کی پناہ میں آتا ہوں جو عظمت والا ہے پھڑکتی رگ اور آگ کی گرمی سے",
            translationEnglish:
                "I seek relief taking Allah's great blessed name from all the evils of pulling (pulsating) nerves and from the evils of the hot fire",
            icon: Icons.thermostat,
          ),
          DuaModel(
            title: "چھینک آنے کے وقت کی دعا",
            dua: "الْحَمْدُ لِلَّهِ",
            translationUrdu: "تمام تعریفیں اللہ عزوجل کےلئے ہیں۔",
            translationEnglish: "All praise onto Allah Almighty.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "چھینک آنے پر الحمد للہ کہنے والے کے لئے دعا",
            dua: "يَرْحَمُكَ اللَّهُ",
            translationUrdu: "اللہ عزوجل تجھ پر رحم کرے۔",
            translationEnglish: "May Allah Almighty Have Mercy on you.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "مریض کی عیادت کی دعا",
            dua: "لَابَأْسَ طُہُوْر اِنْ شَآ ئَ اللّٰہ۔",
            translationUrdu:
                "کچھ ڈرنہیں، ان شاء اللہ تعالیٰ یہ بیماری گناہوں سے پاک کرنے والی ہے ۔",
            translationEnglish:
                "There is no problem, If Allah wills, He will purge your sins by this illness.",
            icon: Icons.personal_injury,
          ),
          DuaModel(
            title: "آنکھ میں درد کی دعا",
            dua:
                "اللَّهُمَّ مَتِّعْنِي بِبَصَرِي وَاجْعَلْهُ الْوَارِثَ مِنِّي وَأَرِنِي فِي الْعَدُوِّ ثَأْرِي وَانْصُرْنِي عَلَى مَنْ ظَلَمَنِي",
            translationUrdu:
                "اے اللہ! میری بینائی سے مجھے نفع پہنچا اور میرے مرتے دم تک اسے باقی رکھ اور دشمن میں میر ا نتقام مجھے دکھا اور جس نے مجھ پر ظلم کیا اس کے مقابلے میں میری مدد فرما۔",
            translationEnglish:
                "O Allah grant me benefit from my eyesight and keep it (maintain it) till my death and give me power over my enemies and give me aid against those who oppress me",
            icon: Icons.remove_red_eye_rounded,
          ),
          DuaModel(
            title: "مریض کی شفایابی کی دعا",
            dua:
                "اَسْأَلُ اللّٰہَ الْعَظِیْمَ رَبَّ الْعَرْشِ الْعَظِیْمِ اَنْ یَّشْفِیَکَ۔ (سبع مرات)",
            translationUrdu:
                "عرش عظیم کے بلند وبالا خدا سے آپ کی صحت کا سؤال کرتا ہوں۔(سات مرتبہ)",
            translationEnglish:
                "I ask Allah who is the Lofty and the Lord of the Mighty Throne that He cures you",
            icon: Icons.healing_outlined,
          ),
          DuaModel(
            title: "جسم میں درد کی دعا",
            dua:
                "أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ",
            translationUrdu:
                "میں اللہ اور اس کی قدرت کی پناہ مانگتا ہوں اس تکلیف سے جو میں محسوس کر رہا ہوں اور جس کا مجھے ڈر ہے",
            translationEnglish:
                "I seek refuge in Allah and His power from the evil of what I feel and what I fear.",
            icon: Icons.boy_rounded,
          ),
          DuaModel(
            title: "پیشاب کو جاری کرنے اور پتھری کو دور کرنے کی دعا",
            dua:
                "رَبُّنَا اللَّهُ الَّذِي فِي السَّمَاءِ تَقَدَّسَ اسْمُكَ أَمْرُكَ فِي السَّمَاءِ وَالْأَرْضِ كَمَا رَحْمَتُكَ فِي الْأَرْضِ وَاغْفِرْ لَنَا حَوْبَنَا وَخَطَايَانَا أَنْتَ رَبُّ الطَّيِّبِينَ فَأَنْزِلْ شِفَاءً مِنْ شِفَائِكَ وَرَحْمَةً مِنْ رَحْمَتِكَ عَلَى هَذَا الْوَجَعِ",
            translationUrdu:
                "اے ہمارے رب، خدا جو آسمان پر ہے، تیرا نام، تیرا حکم آسمان و زمین پر پاک ہے، جس طرح تو نے زمین پر رحم کیا، اور ہماری خطاؤں اور ہمارے گناہوں کو معاف فرما، تو ہی رب العزت ہے، تو اس درد پر اپنی شفاء اور اپنی رحمت سے کوئی رحمت نازل فرما۔",
            translationEnglish:
                "Our Lord is Allah who is in the skies (worthy of worship). Your name is Pure. Your authority is prevalent in the sky and earth, just as Your Mercy is in the sky thus lower it on earth as well and forgive our sins and errors. You are the Lord of the pure ones thus descend upon this pain a cure (relief) from Your reliefs/cures and descend a Mercy from amongest Your Mercies on this pain",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "کوئی مصیبت آئے تو یہ دعاپڑھے",
            dua:
                "اِنَّالِلّٰہِ وَاِنَّااِلَیْہِ رَاجِعُوْنَ،اَللّٰھُمَّ أْجُرْنِیْ فِیْ مُصِیْبَتِیْ وَاَخْلِفْ لِیْ خَیْرًامِّنْھَا۔",
            translationUrdu:
                "ہم تو اللہ ہی کے ہیں اور اس کی طرف لوٹ کر جانے والے ہیں ، اے اللہ !مجھے اپنی مصیبت میں اجر دے اوراس کا نعم البدل عطا فرما۔",
            translationEnglish:
                "Definitely we are from Allah and to Him is our return. O Allah, grant reward in my calamity and grant in its place a good substitute",
            icon: FlutterIslamicIcons.solidAllah,
          ),
        ],
      ),
      //________________________ Weather _______________________________

      DuaCategoryModel(
        name: "Weather",
        duas: [
          DuaModel(
            title: "بارش کی دعا - دعاءِ استسقاء",
            dua:
                "اللّهُمَّ اَسْقِـنا غَيْـثاً مُغيـثاً مَريئاً مُريـعاً، نافِعـاً غَيْـرَ ضَّارٌ، عاجِـلاً غَـيْرَ آجِلٍ",
            translationUrdu:
                "اے اللہ! ہمیں ایسی بارش عطا فرما جو فائدہ دینے والی، سیراب کرنے والی، خوشگوار اور بابرکت ہو، جو نفع بخش ہو اور نقصان دہ نہ ہو، اور جلد نازل ہو، تاخیر نہ ہو۔",
            translationEnglish:
                "O Allah, grant us rain that is beneficial, plentiful, wholesome, and fruitful, that brings benefit and not harm, and that comes quickly and not delayed.",
            icon: Icons.cloudy_snowing,
          ),
          DuaModel(
            title: "آندھی کے وقت کی دعا",
            dua:
                "اَللّٰہُمَّ اِنِّیْ اَسْئَلُکَ خَیْرَھَا وَخَیْرَمَافِیْھَاوَخَیْرَ مَااُرْسِلَتْ بِہ وَاَعُوْذُبِکَ مِنْ شَرِّھَا وَشَرِّ مَافِیْھَاوَشَرِّ مَااُرْسِلَتْ بِہ۔",
            translationUrdu:
                "اے اللہ !میں آپ سے اس کی خیر اور جو اس میں ہے اور جس کے ساتھ بھیجی گئی ہے بہتری کا سؤال کرتا ہوں اور اس کی برائی اور جوکچھ اس میں ہے اور جس کے ساتھ بھیجی گئی ہے سے پناہ مانگتا ہوں۔",
            translationEnglish:
                "O Allah i ask you for its goodness, the good with in it, and the good it was sent with, and i take refuge with you from its evil, the evil within it, and from the evil it was sent with.",
            icon: Icons.air_outlined,
          ),
          DuaModel(
            title: "بجلی کی کڑک کے وقت کی دعا",
            dua:
                "اللَّهُمَّ لَا تَقْتُلْنَا بِغَضَبِكَ وَلَا تُهْلِكْنَا بِعَذَابِكَ وَعَافِنَا قَبْلَ ذَلِكَ",
            translationUrdu:
                "اے اللہ ہمیں اپنے غضب سے نہ مارنا، اپنے عذاب سے ہمیں ہلاک نہ کرنا، اور اس سے پہلے ہمیں معاف فرما۔",
            translationEnglish:
                "O Allah, do not let us die by Your anger and do not destroy us with Your punishment, but grant us safety",
            icon: Icons.thunderstorm_sharp,
          ),
          DuaModel(
            title: "کثرت بارش سےبچنے کی دعا",
            dua:
                "اللَّهُمَّ حَوَالَيْنَا وَلَا عَلَيْنَا اللَّهُمَّ عَلَى الْأَكَامِ وَالْأَجَامِ وَالظِّرَابِ وَالْأَدْوِيَةِ وَمَنَابِةِ الشَّجَرِ",
            translationUrdu:
                "اے اللہ ہمارے اطراف میں بارش برسا (جہاں ضرورت ہے) ہم پر نہ برسا۔ اے اللہ ! ٹیلوں ، پہاڑوں، وادیوں اور درخت اگنے کی جگہ پر بارش برسا۔",
            translationEnglish:
                "O Allah, let it rain around us and not on us. O Allah, let it rain on the peaks and mountains and the rivers and at the forests",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "بارش طلب کرنے کی دعا",
            dua: "اللَّهُمَّ أَغِثْنَا",
            translationUrdu: "اے اللہ ہمیں بارش دے",
            translationEnglish: "O Allah, listen to our plea (request)",
            icon: Icons.cloudy_snowing,
          ),
          DuaModel(
            title: "بارش کے وقت کی دعا",
            dua: "اللَّهُمَّ صَيِّبَاً نَافِعَاً",
            translationUrdu: "اے اللہ اسے نفع دینے والی بارش بنا دے",
            translationEnglish: "O Allah make it plentiful and beneficial",
            icon: Icons.water_drop_rounded,
          ),
        ],
      ),

      //________________________ Home & family _______________________________

      DuaCategoryModel(
        name: "Home & family",
        duas: [
          DuaModel(
            title: "والدین کے لیے دعا",
            dua: "رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا",
            translationUrdu:
                "اے میرے رب! ان (میرے والدین) پر رحم فرما، جس طرح انہوں نے بچپن میں میری پرورش کی۔",
            translationEnglish:
                "My Lord, have mercy upon them (my parents) as they brought me up when I was small.",
            icon: FlutterIslamicIcons.solidFamily,
          ),
          DuaModel(
            title: "بچوں کے لیے دعا",
            dua:
                "رَبِّ هَبْ لِي مِنْ لَدُنْكَ ذُرِّيَّةً طَيِّبَةً ۖ إِنَّكَ سَمِيعُ الدُّعَاءِ",
            translationUrdu:
                "اے میرے رب! مجھے اپنی طرف سے نیک اولاد عطا فرما، بے شک تو دعا سننے والا ہے۔",
            translationEnglish:
                "My Lord, grant me from Yourself a good (righteous) offspring. Indeed, You are the Hearer of supplication.",
            icon: Icons.child_care_outlined,
          ),
          DuaModel(
            title: "مومن سے مومن کی ملاقات کے وقت کی دعا",
            dua: "السَّلَامُ عَلَيْكُمُ - وَعَلَيْكُمُ السَّلَامُ",
            translationUrdu: "تم پر سلامتی ہو۔ اور تم پر بھی سلامتی ہو۔",
            translationEnglish: "Peace be upon you And peace be upon you too.",
            icon: Icons.handshake,
          ),
          DuaModel(
            title: "کسی مسلمان کو ہنستا دیکھ کر پڑھنے کی دعا",
            dua: "أَضْحَكَ اللَّهُ سِنَّكَ",
            translationUrdu: "اللہ عزوجل تجھے ہنستا رکھے۔",
            translationEnglish: "May Allah Almighty Keep you smiling.",
            icon: Icons.mood,
          ),
          DuaModel(
            title: "گھر میں داخل ہونے کی دعا",
            dua:
                "اَللّٰھُمَّ اِنِّیْ اَسْئَلُکَ خَیْرَالْمَوْلِجِ وَخَیْرَالْمَخْرَجِ بِسْمِ اللّٰہِ وَلَجْنَا وَبِسْمِ اللّٰہِ خَرَجْنَا وَعَلَی اللّٰہِ رَبِّنَا تَوَکَّلْنَا ۔",
            translationUrdu:
                "اے اللہ !میں سؤال کرتا ہوں آپ سے اچھے داخلہ کا اور اچھی طرح نکلنے کا ،اللہ کے نام سے میں داخل ہوا ،اللہ کے نام سے میں نکلااور اپنے رب اللہ پر میں نے بھروسہ کیا ۔",
            translationEnglish:
                "O Allah, I seek a good entry and a good exit. We take Allah's name to enter and to exit and rely on Him who is our Lord.",
            icon: Icons.home,
          ),
          DuaModel(
            title: "گھر سے نکلنے کی دعا",
            dua:
                "بِسْمِ اللّٰہِ تَوَکَّلْتُ عَلَی اللّٰہِ لَاحَوْلَ وَلَاقُوَّةَ اِلَّابِاللّٰہِ۔",
            translationUrdu:
                "اللہ تعالیٰ کے نام کے ساتھ گھر سے نکلتا ہوں،اللہ تعالیٰ پر میں نے بھروسہ کیا ،گناہوں سے بچنے اور عبادت کرنے کی توفیق اللہ تعالیٰ ہی دیتے ہیں۔",
            translationEnglish:
                "I depart with Allah's name, relying on Him. It is Allah who saves us from sins with His guidance (the ability to do so)",
            icon: Icons.logout_outlined,
          ),
          DuaModel(
            title: "بیت الخلاء میں داخل ہونے سے پہلے کی دعا",
            dua:
                "اَللّٰہُمَّ اِنِّیْ اَعُوْذُبِکَ مِنَ الْخُبُثِ وَالْخَبَآئِثِ۔",
            translationUrdu:
                "اے اللہ !میں آپ کی پناہ پکڑتا ہوں تمام شیاطین (مردوں اورعورتوں) کے شرسے۔",
            translationEnglish:
                "O Allah (Almighty) I seek your refuge from impure Jinnat (male and female)",
            icon: Icons.bathroom,
          ),
          DuaModel(
            title: "بیت الخلاء سے باہر آنے کے بعد کی دعا",
            dua:
                "اَلْحَمْدُ لِلّٰہِ الَّذِیْ اَذْھَبَ عَنِّی الْاَذٰی وَعَافَانِیْْ ۔",
            translationUrdu:
                "شکر ہے اس اللہ کا جس نے مجھ سے گندگی دور کردی اور مجھ کوعافیت دی۔",
            translationEnglish:
                "Thanks to Allah Almighty Who removed pain from me and granted me relief.",
            icon: Icons.bathroom,
          ),
        ],
      ),

      //________________________ Safety & Evil Eye _______________________________

      DuaCategoryModel(
        name: "Safety & Evil Eye",
        duas: [
          DuaModel(
            title: "مظلوم کی دعا",
            dua: "رَبِّ نَجِّنِى وَأَهْلِى مِمَّا يَعْمَلُونَ",
            translationUrdu:
                "اے میرے رب! مجھے اور میرے اہلِ خانہ کو ان کے اعمال سے نجات دے۔",
            translationEnglish:
                "My Lord, save me and my family from (the consequences of) what they do.",
            icon: Icons.safety_check_rounded,
          ),
          DuaModel(
            title: "نظر بد سے بچنے کی دعا",
            dua:
                "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لاَمَّةٍ",
            translationUrdu:
                "میں اللہ کے کامل کلمات کے ذریعے ہر شیطان اور زہریلے جانور سے، اور ہر نقصان دہ نظر (نظر بد) سے پناہ مانگتا ہوں۔",
            translationEnglish:
                "I seek refuge in the perfect words of Allah from every devil and poisonous creature, and from every evil and envious eye",
            icon: Icons.remove_red_eye_rounded,
          ),
          DuaModel(
            title: "جانور کو نظر لگ جانے پر پڑھنے کی دعا",
            dua:
                "لَا بَأْسَ أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ اشْفِ أَنْتَ الشَّافِي لَا يَكْشِفُ الضُّرَّ إِلَّا أَنْتَ",
            translationUrdu:
                "کوئی ڈر نہیں ہے(اے) انسانوں کے رب بیماری دور کردے اور شفادے دے کیوں کہ تو ہی شفا دینے والا ہے۔ تیرے سوا کوئی نقصان دور نہیں کر سکتا۔",
            translationEnglish:
                "There is no problem, O Lord of mankind, remove the difficulty (and) grant relief for you are the One who grants relief. There is no one but You who removes difficulties.",
            icon: FlutterIslamicIcons.solidCow,
          ),
          DuaModel(
            title:
                "گدھے یا کتے کی آواز سنے یا غصہ اور برے وسوسے آئیں تو یہ پڑھے",
            dua: "اَعُوْذُ بِاللّٰہِ مِنَ الشَّیْطٰنِ الرَّجِیْمِ۔",
            translationUrdu: "شیطان مردود سے اللہ تعالیٰ کی پناہ مانگتا ہوں۔",
            translationEnglish:
                "I seek refuge with Allah from the accursed shaitan",
            icon: Icons.pets,
          ),
          DuaModel(
            title: "دشمن کا خوف ہو تو یہ دعا پڑھے",
            dua:
                "اَللّٰہُمَّ اِنَّا نَجْعَلُکَ فِیْ نُحُوْرِ ھِمْ وَنَعُوْذُبِکَ مِنْ شُرُوْرِ ھِمْ ۔",
            translationUrdu:
                "یااللہ !آپ ہی کو دشمن کے سامنے لاتے ہیں اور ان کی شرارتوں سے آپ کی پناہ مانگتے ہیں۔",
            translationEnglish:
                "O Allah, we make you the turner of the (enemies) chest (heart) and seek refuge in You from their evils",
            icon: Icons.dangerous,
          ),
          DuaModel(
            title: "دشمنوں پر فتح کی دعا",
            dua:
                "اللَّهُمَّ مُنْزِلَ اْلِكتَابِ ، سَرِيْعَ الْحِسَابِ ،اِهْزِمِ الإْحْزَابَ ،اللَّهُمَّ اِهْزِمْهُمْ وَزَلْزِلْهُمْ",
            translationUrdu:
                "اے اللہ! کتاب کے نازل کرنے والے (قیامت کے دن) حساب بڑی سرعت سے لینے والے، اے اللہ! مشرکوں اور کفار کی جماعتوں کو (جو مسلمانوں کا استیصال کرنے آئی ہیں) شکست دے۔ اے اللہ! انہیں شکست دے اور انہیں جھنجھوڑ کر رکھ دے۔",
            translationEnglish:
                "O Allah! The Revealer of the Holy Book, the Swift-Taker of Accounts, O Allah, defeat Al-Ahzab (i.e. the clans), O Allah, defeat them and shake them.",
            icon: Icons.check_box_sharp,
          ),
          DuaModel(
            title: "غصہ آنے کے وقت کی دعا",
            dua: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
            translationUrdu: "میں شیطان مردود سے اللہ عزوجل کی پناہ چاہتا ہوں۔",
            translationEnglish:
                "I seek the refuge of Allah Almighty from the rejected Shetan.",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "قسمت کی دعا",
            dua:
                "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً وَرِزْقاً طَيِّباً وَعَمَلاً مُتَقَبَّلاً",
            translationUrdu:
                "اے اللہ! میں تجھ سے نفع بخش علم، پاکیزہ رزق، اور مقبول عمل کا سوال کرتا ہوں۔",
            translationEnglish:
                "O Allah, I ask You for beneficial knowledge, pure (lawful) sustenance, and accepted deeds.",
            icon: FlutterIslamicIcons.solidSajadah,
          ),
        ],
      ),

      //________________________ Life & Death _______________________________

      DuaCategoryModel(
        name: "Life & Death",
        duas: [
          DuaModel(
            title: "نماز جنازہ کی دعا",
            dua:
                "اللهُـمِّ اغْفِـرْ لِحَيِّـنا وَمَيِّتِـنا وَشـاهِدِنا ، وَغائِبِـنا ، وَصَغيـرِنا وَكَبيـرِنا ، وَذَكَـرِنا وَأُنْثـانا . اللهُـمِّ مَنْ أَحْيَيْـتَهُ مِنّا فَأَحْيِـهِ عَلى الإِسْلام ،وَمَنْ تَوَفَّـيْتََهُ مِنّا فَتَوَفَّـهُ عَلى الإِيـمان ، اللهُـمِّ لا تَحْـرِمْنـا أَجْـرَه ، وَلا تُضِـلَّنا بَعْـدَهُ",
            translationUrdu:
                "اے اللہ! ہمارے زندہ اور مردہ کو، ہمارے چھوٹے اور بڑے کو، ہمارے مردوں اور عورتوں کو، ہمارے حاضر اور غائب سب کو بخش دے۔ اے اللہ! ہم میں سے جس کو تو زندہ رکھے اسے اسلام پر زندہ رکھ اور ہم میں سے جسے موت دے اسے ایمان پر موت دے۔ اے اللہ! ہمیں اس کے اجر سے محروم نہ کر اور ہمیں اس کے بعد کسی فتنے میں مبتلا نہ کر",
            translationEnglish:
                "O Allah! Forgive our living and our dead, those who are present and those who are absent, our young and our old, our males and our females. O Allah! Whoever You keep alive from among us, keep them alive upon Islam, and whoever You take away from us, take them away upon faith. O Allah! Do not deprive us of their reward, and do not let us go astray after them.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
          DuaModel(
            title: "زندگی اور موت کی دعا",
            dua:
                "اللَّهُمَّ أَحْيِنِي مَا كَانَتِ الْحَيَاةُ خَيْرٌ لِي وَتَوَفَّنِي إِذَا كَانَتِ الْوَفَاةُ خَيْرَاً لِي",
            translationUrdu:
                "اے اللہ! جب تک میرے لیے زندگی بہتر ہے مجھے زندہ رکھیو اور جب میرے لیے موت بہتر ہو تو مجھے اٹھا لیجیو۔",
            translationEnglish:
                "O Allah keep me alive as long as is good for me and when death is better for me lift me",
            icon: CupertinoIcons.link,
          ),
          DuaModel(
            title: "میت کے لیے دعا",
            dua:
                "اللَّهُمَّ عَبْدُكَ وَابْنُ أَمَتِكَ احْتَاجَ إِلَى رَحْمَتِكَ، وَأَنْتَ غَنِيٌّ عَنْ عَذَابِهِ، إِنْ كَانَ مُحْسِناً فَزِدْ فِي حَسَنَاتِهِ، وَإِنْ كَانَ مُسِيئاً فَتَجَاوَزْ عَنْهُ",
            translationUrdu:
                "اے اللہ! تیرا بندہ اور تیری بندی کا بیٹا تیری رحمت کا محتاج ہے، اور تو اس کے عذاب سے بے نیاز ہے۔ اگر وہ نیک تھا تو اس کی نیکیوں میں اضافہ فرما، اور اگر وہ گناہ گار تھا تو اس سے درگزر فرما۔",
            translationEnglish:
                "O Allah, Your servant and the son of Your maidservant is in need of Your mercy, and You are not in need of punishing him. If he was righteous, increase his good deeds, and if he was sinful, then pardon him.",
            icon: Icons.hotel_sharp,
          ),
          DuaModel(
            title: "شہادت کی دعا",
            dua:
                "اَللّٰہُمَّ ارْزُقْنِیْ شَہَادَةً فِیْ سَبِیْلِکَ وَاجْعَلْ مَوْتِیْ فِیْ بَلَدِ رَسُوْلِکَ صَلَّی اللّٰہُ عَلَیْہِ وَسَلََّمَ۔",
            translationUrdu:
                "اے اللہ مجھے اپنے راستے میں شہادت نصیب فرما اور اپنے رسول کے شہر میں میری موت واقع کردے۔",
            translationEnglish:
                "O Allah, grant me martyrdom in Your path and cause me to die in the city of Your Messenger. (Prophet PBUH )",
            icon: FlutterIslamicIcons.solidTawhid,
          ),
          DuaModel(
            title: "قبرستان میں داخل ہوتے وقت کی دعا",
            dua:
                "اَلسَّلَامُ عَلَیْکُمْ اَھْلَ الدِّیَارِ مِنَ الْمُؤْمِنِیْنَ وَالْمُسْلِمِیْنَ ،وَاِنَّااِنْ شَآئَ اللّٰہُ بِکُمْ لَلاَحِقُوْنَ أَسْأَلُ اللّٰہَ لَنَا وَلَکُمُ الْعَافِیَةَ۔",
            translationUrdu:
                "اے مؤمنو !تم پر سلام ہو ،ہم آپ کے پاس جلد آنے والے ہیں ، اپنے لئے اور آپ کے لئے اللہ تعالیٰ سے عافیت وخیریت مانگتے ہیں۔",
            translationEnglish:
                "Peace be upon you O inhabitants of the abodes, believers and Muslims, we will join you if Allah wills, we ask Allah for our and your well being.",
            icon: Icons.login,
          ),
          DuaModel(
            title: "میت کو قبر میں رکھتے وقت کی دعا",
            dua: "بِسْمِ اللَّهِ وَعَلٰی سُنَّةِ رَسُولِ اللَّهِ",
            translationUrdu:
                "اللہ عزوجل کے نام سے اور رسول اللہ صلی اللہ علیہ وسلم کے طریقہ پر (اسے دفن کرتا ہوں)۔",
            translationEnglish:
                "Allah Azzawajal in the name of and according to the way of Messenger SAW (It is burried).",
            icon: FlutterIslamicIcons.solidPrayer,
          ),
          DuaModel(
            title: "تعزیت کی دعا",
            dua:
                "اِنَّ لِلّٰہِ مَاأَخَذَ وَلَہ مَاأَعْطٰی، وَکُلُّ شَیْیٍٔ عِنْدَہ بِأَجَلٍ مُّسَمًّی فَلْتَصْبِرْ وَلْتَحْتَسِبْ۔",
            translationUrdu:
                "اللہ ہی کا ہے جو کچھ اس نے لے لیا اور جو کچھ دیا وہ بھی اسی کا ہے اور اس کے یہاں ہر چیز کا وقت متعین ہے ، آپ صبر کریں اور ثواب کی امید رکھیں۔",
            translationEnglish:
                "verily to Allah, belongs what he took and to him belongs what he gave, and everything with him has an appointed time, and then he ordered for her to be patient and hope for Allah's reward.",
            icon: Icons.meeting_room_rounded,
          ),
          DuaModel(
            title: "حسنِ خاتمہ کی دعا",
            dua:
                "اَللّٰہُمَّ لَقِّنِیْ حُجَّةَالْاِیْمَانِ عِنْدَ الْمَمَاتِ ۔",
            translationUrdu:
                "اے اللہ !مجھے موت کے وقت ایمان کی حجت ودلیل نصیب فرما۔",
            translationEnglish:
                "O Allah, grant me the proof and evidence of faith at the time of death.",
            icon: FlutterIslamicIcons.solidPrayingPerson,
          ),
        ],
      ),

      //________________________ Eid ul Adha _______________________________

      DuaCategoryModel(
        name: "Eid ul Adha",
        duas: [
          DuaModel(
            title: "قربانی کے وقت کی دعا",
            dua:
                "إِنِّي وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ السَّماَوَاتِ وَالأَرْضَ مِلَّةَ إِبْرَاهِيمَ حَنِيفَاً وَمَا أَنَا مِنَ الْمُشْرِكِينَ . إِنَّ صَلاتِي وَنُسُكِي وَمَحْيَايَ وَمَمَاتِي لِلَّهِ رَبِّ العَالَمِينَ لاَ شَرِيكَ لَهُ وَبِذَلِكَ أُمِرْتُ وَأَنَا أَوَّلُ المُسْلِمِينَ ، اللَّهُمَّ مِنْكَ وَلَكَ",
            translationUrdu:
                "میں نے اپنا رخ اس ہستی کی طرف پھیر لیا ہے جس نے آسمانوں اور زمین کو دین ابراہیم کی حالت میں پیدا کیا ہے اور میں مشرکوں میں سے نہیں ہوں۔ بے شک میری نماز، میری عبادت اور میرا جینا مرنا سب اللہ کے لیے ہے جو تمام جہانوں کا رب ہے اور جس کا کوئی شریک نہیں۔ مجھے حکم دیا گیا ہے (جو گزر چکا ہے) میں مسلمانوں میں سے ہوں۔ اے اللہ یہ قربانی تیری وجہ سے ہے ہمیں اس کی توفیق عطا فرما اور تیرے لیے ہے۔",
            translationEnglish:
                "I have turned my face to that Being who has created the skies and the Earth in the state of the Straight Deen of Ibrahim - and I am not amongst the Mushrikeen. Definitely, my Salaat, my Ibadat and my living and dying is all for Allah, who is the Lord of the worlds, and who has no partner. I have been ordered (all that passed) I am amongst the Muslimeen (the obedient). O Allah this sacrifice is due to You granting us the ability to do so and it is for You",
            icon: FlutterIslamicIcons.solidCow,
          ),
          DuaModel(
            title: "نئے جانور کے آمد کے وقت کی دعا",
            dua:
                "اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا جَبَلْتَهَا عَلَيْهِ وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَّرَّ مَا جَبَلْتَهَا عَلَيْهِ",
            translationUrdu:
                "اے اللہ میں تجھ سے اس میں بھلائی چاہتا ہوں اور اس کی عادت و کردار میں بھلائی چاہتا ہوں اور اس کی برائیوں اور اخلاق سے تیری پناہ چاہتا ہوں۔",
            translationEnglish:
                "O Allah, I seek the good in it from You and the goodness in the habit and character in it/her and seek refuge in You from its/her evil habits and character",
            icon: FlutterIslamicIcons.solidSheep,
          ),
        ],
      ),

      //________________________ Travel _______________________________

      DuaCategoryModel(
        name: "Travel",
        duas: [
          DuaModel(
            title: "سفر کے لئے نکلنے کی دعا",
            dua:
                "بِسْمِ اللّٰہِ تَوَکَّلْتُ عَلَی اللّٰہِ، اَللّٰھُمَّ بِکَ اَصُوْلُ وَبِکَ اَحُوْلُ وَبِکَ اَسِیْرُ، اَللّٰہُمَّ اَنْتَ الصَّاحِبُ فِی السَّفَرِ وَالْخَلِیْفَةُ فِی الْاَھْلِ ۔",
            translationUrdu:
                "اللہ تعالیٰ کے نام کے ساتھ سفر شروع کرتا ہوں،اللہ پر میں نے بھروسہ کیا ،اے اللہ! آپ ہی کی مدد سے جاتا ہوں اور آپ ہی کی مدد سے واپس آتاہوں اور آپ ہی کی مددسے چلتا ہوں، اے اللہ ! آپ ہی رفیق ہیں سفر میں اور خبر گیر ہیں گھر بار میں۔",
            translationEnglish:
                "In the name of Allah, I place my trust in Allah. O Allah, it is with Your help that I attack (the enemy) and with Your help I defend and with Your help I depart. O Allah, You are The Companion on the journey and The Successor over the family",
            icon: Icons.logout,
          ),
          DuaModel(
            title: "سواری پربیٹھ کر یہ دعاء پڑھے",
            dua:
                "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
            translationUrdu:
                "پاک ہے وہ ذات جس نے ہمارے لیے اس (سواری) کو مسخر کر دیا، حالانکہ ہم اسے قابو میں لانے کی طاقت نہیں رکھتے تھے، اور بیشک ہم اپنے رب ہی کی طرف لوٹ کر جانے والے ہیں۔",
            translationEnglish:
                "Glory be to Him who has subjected this (transport) to us, and we could never have had control over it. And indeed, to our Lord, we shall return.",
            icon: Icons.directions_bike_sharp,
          ),
          DuaModel(
            title: "سفر سے واپسی کی دعا",
            dua:
                "اٰ ئِبُوْنَ تَآئِبُوْنَ عَابِدُوْنَ سَاجِدُوْنَ لِرَبِّنَاحَامِدُوْنَ ۔",
            translationUrdu:
                "ہم سفر سے آنیوالے ہیں ،توبہ کرنے والے ہیں، عبادت کرنے والے ہیں ،سجدہ کرنے والے ہیں اور اپنے پروردگارکی حمد کرنے والے ہیں۔",
            translationEnglish:
                "We return, repent, worship and praise our Lord.",
            icon: Icons.electric_bike,
          ),
          DuaModel(
            title: "بازار جائے تویہ دعا پڑھے",
            dua:
                "بِسْمِ اللّٰہِ، اَللّٰھُمَّ اِنِّیْ اَسْئَلُکَ خَیْرَ ھٰذِہِ السُّوْقِ وَخَیْرَمَافِیْھَاوَاَعُوْذُبِکَ مِنْ شَرِّ ھَا وَشَرِّمَافِیْھَااَللّٰھُمَّ اِنِّیْ اَعُوذُبِکَ اَنْ اُصِیْبَ فِیْھَایَمِیْنًا فَاجِرَةً اَوْصَفْقَةً خَاسِرَةً۔",
            translationUrdu:
                "اللہ کے نام سے بازار میں داخل ہوتا ہوں،یااللہ! میں آپ سے اس بازار کی بھلائی مانگتاہوں اور اس چیز کی بھلائی جو اس میں ہے اور آپ کی پناہ چاہتا ہوں اس کی برائی سے اوراس چیز کی برائی سے جو اس میں ہے، یااللہ! میں آپ کی پناہ چاہتا ہوں اس سے کہ میں اس بازار میں جھوٹی قسم اور خسارہ کے معاملہ میں پڑجائوں۔",
            translationEnglish:
                "I entered in the name of Allah, I seek refuge in You (Allah) for the good in the bazaar and for the good of what is in it (the bazaar). O Allah, I seek refuge in you from false oaths and deception in transaction",
            icon: Icons.store,
          ),
          DuaModel(
            title: "کسی منزل پر پہنچنے کی دعاء",
            dua:
                "اَعُوْذُبِکَلِمَاتِ اللّٰہِ التَّآمَّاتِ مِنْ شَرِّ مَاخَلَقَ۔",
            translationUrdu:
                "میں پناہ پکڑتاہوں اللہ تعالیٰ کی کامل باتوں کی ،تمام مخلوق کی برائی سے۔",
            translationEnglish:
                "I seek refuge in Allah by His complete words from the evils of the creation",
            icon: Icons.place,
          ),
          DuaModel(
            title: "شہریا بستی میں داخل ہونے کی دعا",
            dua:
                "اَللّٰھُمَّ بَارِکْ لَنَافِیْھَا، اَللّٰھُمَّ ارْزُقْنَاجَنَاھَاوَحَبِّبْنَا اِلٰی اَھْلِھَاوَحَبِّبْ صَالِحِیْ اَھْلِھَااِلَیْنَا۔",
            translationUrdu:
                "اے اللہ !ہمیں اس شہر میں برکت دیجئے ، یااللہ ! ہمیں اس کے ثمرات نصیب کیجئے اور اہل شہر کے نزدیک عزیز کیجئے اور یہاںکے نیک لوگوں کی محبت ہمیں دیجئے۔",
            translationEnglish:
                "O Allah, You grant us good in it (the city/populated area). O Allah, grant us the fruit of this place and create love in the people for us and create love in our hearts for the righteous people (of this area).",
            icon: Icons.location_city_sharp,
          ),
        ],
      ),
      //________________________ Hajj _______________________________

      DuaCategoryModel(
        name: "Hajj",
        duas: [
          DuaModel(
            title: "حج تلبیہ",
            dua:
                "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ ، لَا شَرِيكَ لَكَ",
            translationEnglish:
                "I am present, O Allah, I am present, there is no partner unto You. I am present. Definitely praise and glory is yours (for You). The Kingdom is also Yours. There is no partner for You",
            translationUrdu:
                "میں حاضر ہوں، اے اللہ میں حاضر ہوں، تیرا کوئی شریک نہیں۔ میں حاضر ہوں۔ بے شک حمد و ثناء تیری ہی ہے۔ بادشاہی بھی تیری ہے۔ تیرا کوئی شریک نہیں۔",
            icon: FlutterIslamicIcons.solidHadji,
          ),
          DuaModel(
            title: "طواف کرتے وقت کی دعا",
            dua:
                "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
            translationUrdu:
                "اللہ پاک ہے اور میں اللہ کی حمد کرتا ہوں، اس کے سوا کوئی عبادت کے لائق نہیں، وہ سب سے بڑا ہے۔ اللہ وہ ہے جو ہمیں گناہوں سے روکتا ہے اور نیکی کرنے کی توفیق عطا کرتا ہے۔",
            translationEnglish:
                "Allah is pure and I praise Allah, there is none worthy of worship besides Him, He is the Greatest. Allah is the One who turns us away from sin and grants the ability to do good",
            icon: FlutterIslamicIcons.solidKaaba,
          ),
          DuaModel(
            title: "عرفات کے مقام پر پرھنے کی دعا",
            dua:
                "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٍ . اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورَاً وَفِي سَمْعِي نُورَاً وَفِي بَصَرِي نُورَاً اللَّهُمَّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَأَعُوذُ بِكَ مِنْ وَسَاوِسِ الصُّدُورِ وَشَتَاتِ الْأَمْرِ وَفِتْنَةِ الْقَبْرِ اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ مَا يَلِجُ فِي اللَّيْلِ وَشَرِّ مَا يَلِجُ فِي النَّهَارِ وَشَرِّ مَا تَهِبُّ بِهِ الرِّيَاحُ",
            translationUrdu:
                "اللہ کے سوا کوئی عبادت کے لائق نہیں، وہ سب کچھ اپنی ذات سے ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہی ہے، اسی کے لیے تمام تعریفیں ہیں، وہ ہر چیز پر قادر ہے۔ اے اللہ میرے دل میں نور بنا، کانوں میں نور اور آنکھوں میں نور بنا۔ اے اللہ میرا سینہ کھول دے، میرے کاموں کو آسان کردے اور میں تیری پناہ چاہتا ہوں سینے کے وسوسوں سے، کام میں بے ترتیبی سے اور عذاب قبر سے۔ اے اللہ میں تیری پناہ مانگتا ہوں ہوا کے ساتھ آنے والے شر سے",
            translationEnglish:
                "There is none worthy of worship besides Allah, He is all by Himself, He has no partner, His is the Kingdom, for Him is all praise, He has power over all things. O Allah, make Nur in my heart, in my ears Nur and in my eyes Nur. O Allah open my chest (bossom), make my tasks easy and I seek refuge in You from the whispers of the chest, from disorganisation in working and from the punishment of the grave. O Allah, I seek refuge in You from the evils that come with the wind",
            icon: Icons.roundabout_right_rounded,
          ),
        ],
      ),
    ];

    // Load user-added categories from SharedPreferences
    List<DuaCategoryModel> userAddedCategories = [];
    if (savedData != null) {
      List<dynamic> decodedList = jsonDecode(savedData);
      userAddedCategories =
          decodedList.map((e) => DuaCategoryModel.fromJson(e)).toList();
    }

    // Merge Preloaded & User-Added Categories
    categories.assignAll([...preloadedCategories, ...userAddedCategories]);

    update();
  }

  Future<void> saveDuaCategories() async {
    final prefs = await SharedPreferences.getInstance();

    // Filter out only user-added categories
    List<Map<String, dynamic>> userAddedCategories = categories
        .where((c) => c.isUserAdded) // Only user-added categories
        .map((c) => c.toJson())
        .toList();

    await prefs.setString(_storageKey, jsonEncode(userAddedCategories));
  }

  void addDuaToCategory(String categoryName, DuaModel dua) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas.add(dua);
    } else {
      categories.add(
          DuaCategoryModel(name: categoryName, duas: [dua], isUserAdded: true));
    }
    categories.refresh();
    update();
    saveDuaCategories();
  }

  void deleteDua(String categoryName, int index) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas.removeAt(index);
      categories.refresh();
      saveDuaCategories(); // Save changes
    }
  }

  void editDua(String categoryName, int index, DuaModel updatedDua) {
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (category != null) {
      category.duas[index] = updatedDua;
      categories.refresh();
      saveDuaCategories(); // Save changes
    }
  }

  void showEditDuaDialog(
      BuildContext context, String categoryName, int index, DuaModel dua) {
    TextEditingController titleController =
        TextEditingController(text: dua.title);
    TextEditingController arabicController =
        TextEditingController(text: dua.dua);
    TextEditingController urduController =
        TextEditingController(text: dua.translationUrdu);
    TextEditingController englishController =
        TextEditingController(text: dua.translationEnglish);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Dua"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: arabicController,
                  decoration: const InputDecoration(labelText: "Arabic Dua"),
                ),
                TextField(
                  controller: urduController,
                  decoration:
                      const InputDecoration(labelText: "Urdu Translation"),
                ),
                TextField(
                  controller: englishController,
                  decoration:
                      const InputDecoration(labelText: "English Translation"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                DuaModel updatedDua = DuaModel(
                  title: titleController.text,
                  dua: arabicController.text,
                  translationUrdu: urduController.text,
                  translationEnglish: englishController.text,
                  icon: dua.icon,
                  isUserAdded: dua.isUserAdded,
                );
                editDua(categoryName, index, updatedDua);
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Dua updated successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Save", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String categoryName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
          title: const Text("Delete Dua"),
          content: const Text("Are you sure you want to delete this Dua?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteDua(categoryName, index); // Call delete function
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Dua deleted successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showAddDuaDialog(BuildContext context, String categoryName) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController duaController = TextEditingController();
    final TextEditingController translationUrduController =
        TextEditingController();
    final TextEditingController translationEnglishController =
        TextEditingController();

    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
      title: "Add New Dua",
      content: Form(
        key: formKey,
        child: Column(
          children: [
            buildTextField(titleController, "Title", true),
            buildTextField(duaController, "Dua in Arabic", true),
            buildTextField(translationUrduController,
                "Translation (Urdu) (optional)", false),
            buildTextField(translationEnglishController,
                "Translation (English) (optional)", false),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addDuaToCategory(
                    categoryName,
                    DuaModel(
                      title: titleController.text,
                      dua: duaController.text,
                      translationUrdu: translationUrduController.text.isEmpty
                          ? ''
                          : translationUrduController.text,
                      translationEnglish:
                          translationEnglishController.text.isEmpty
                              ? ''
                              : translationEnglishController.text,
                      icon: Icons.save,
                      isUserAdded: true,
                    ),
                  );
                  Get.back();
                }
              },
              child: const Text("Add Dua"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hint, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return "$hint is required";
          }
          return null;
        },
      ),
    );
  }

  void showDeleteCategoryDialog(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text(
              "Are you sure you want to delete this category? This will remove all associated Duas."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(categoryName); // Call delete function
                Navigator.of(context).pop(); // Close dialog
                Get.snackbar("Success", "Category deleted successfully",
                    snackPosition: SnackPosition.TOP);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteCategory(String categoryName) {
    categories.removeWhere((c) => c.name == categoryName);
    categories.refresh(); // Update UI
    saveDuaCategories();
  }

  void showEditCategoryDialog(BuildContext context, String oldCategoryName) {
    TextEditingController categoryController =
        TextEditingController(text: oldCategoryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: "Category Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newCategoryName = categoryController.text.trim();
                if (newCategoryName.isNotEmpty &&
                    newCategoryName != oldCategoryName) {
                  editCategoryName(oldCategoryName, newCategoryName);
                  Navigator.of(context).pop(); // Close dialog
                  Get.snackbar("Success", "Category name updated successfully",
                      snackPosition: SnackPosition.TOP);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void editCategoryName(String oldCategoryName, String newCategoryName) {
    final category =
        categories.firstWhereOrNull((c) => c.name == oldCategoryName);
    if (category != null) {
      category.name = newCategoryName;
      categories.refresh(); // Update UI
      saveDuaCategories();
    }
  }

  Future<void> clearStorageOnce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey); // Remove saved data once
  }
}
