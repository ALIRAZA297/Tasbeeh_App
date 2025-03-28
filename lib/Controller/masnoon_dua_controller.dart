import 'dart:convert';
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
            icon: Icons.checkroom_rounded,
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
            translationUrdu: "اے میرے رب! ان (میرے والدین) پر رحم فرما، جس طرح انہوں نے بچپن میں میری پرورش کی۔",
            translationEnglish: "My Lord, have mercy upon them (my parents) as they brought me up when I was small.",
            icon: FlutterIslamicIcons.solidFamily,
          ),
           DuaModel(
            title: "بچوں کے لیے دعا",
            dua: "رَبِّ هَبْ لِي مِنْ لَدُنْكَ ذُرِّيَّةً طَيِّبَةً ۖ إِنَّكَ سَمِيعُ الدُّعَاءِ",
            translationUrdu: "اے میرے رب! مجھے اپنی طرف سے نیک اولاد عطا فرما، بے شک تو دعا سننے والا ہے۔",
            translationEnglish: "My Lord, grant me from Yourself a good (righteous) offspring. Indeed, You are the Hearer of supplication.",
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
            dua: "اَللّٰھُمَّ اِنِّیْ اَسْئَلُکَ خَیْرَالْمَوْلِجِ وَخَیْرَالْمَخْرَجِ بِسْمِ اللّٰہِ وَلَجْنَا وَبِسْمِ اللّٰہِ خَرَجْنَا وَعَلَی اللّٰہِ رَبِّنَا تَوَکَّلْنَا ۔",
            translationUrdu: "اے اللہ !میں سؤال کرتا ہوں آپ سے اچھے داخلہ کا اور اچھی طرح نکلنے کا ،اللہ کے نام سے میں داخل ہوا ،اللہ کے نام سے میں نکلااور اپنے رب اللہ پر میں نے بھروسہ کیا ۔",
            translationEnglish: "O Allah, I seek a good entry and a good exit. We take Allah's name to enter and to exit and rely on Him who is our Lord.",
            icon: Icons.home,
          ),
           DuaModel(
            title: "گھر سے نکلنے کی دعا",
            dua: "بِسْمِ اللّٰہِ تَوَکَّلْتُ عَلَی اللّٰہِ لَاحَوْلَ وَلَاقُوَّةَ اِلَّابِاللّٰہِ۔",
            translationUrdu: "اللہ تعالیٰ کے نام کے ساتھ گھر سے نکلتا ہوں،اللہ تعالیٰ پر میں نے بھروسہ کیا ،گناہوں سے بچنے اور عبادت کرنے کی توفیق اللہ تعالیٰ ہی دیتے ہیں۔",
            translationEnglish: "I depart with Allah's name, relying on Him. It is Allah who saves us from sins with His guidance (the ability to do so)",
            icon: Icons.logout_outlined,
          ),
          DuaModel(
            title: "",
            dua: "",
            translationUrdu: "",
            translationEnglish: "",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "",
            dua: "",
            translationUrdu: "",
            translationEnglish: "",
            icon: Icons.fastfood,
          ),
          DuaModel(
            title: "",
            dua: "",
            translationUrdu: "",
            translationEnglish: "",
            icon: Icons.fastfood,
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
      backgroundColor: Colors.white,
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
