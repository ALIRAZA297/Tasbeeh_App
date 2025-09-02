import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/app_colors.dart';

class CombinedImanScreen extends StatelessWidget {
  const CombinedImanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Iman Basics",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          /// Iman e Mujmal
          IslamicContentCard(
            title: 'ایمانِ مجمل (Iman e Mujmal)',
            arabic:
                'آمَنْتُ بِاللّٰهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَالْقَدَرِ خَيْرِهِ وَشَرِّهِ مِنَ اللّٰهِ تَعَالَىٰ وَالْبَعْثِ بَعْدَ الْمَوْتِ',
            transliteration:
                'Aamantu billaahi wa malaa\'ikatihi wa kutubihi wa rusulihi wal yawmil aakhiri wal qadari khayrihi wa sharrihi minallaahi ta\'aala wal ba\'thi ba\'dal mawt',
            translation:
                'I believe in Allah, His angels, His books, His messengers, the Last Day, and in destiny — its good and bad are from Allah the Most High, and in resurrection after death.',
            urduTranslation:
                'میں ایمان لایا اللہ پر، اس کے فرشتوں پر، اس کی کتابوں پر، اس کے رسولوں پر، قیامت کے دن پر، اور تقدیر پر کہ اس کا اچھا اور برا سب اللہ تعالیٰ کی طرف سے ہے اور موت کے بعد دوبارہ زندہ ہونے پر۔',
            meaningEnglish:
                'This is the basic declaration of faith which includes the six pillars of Iman.',
            meaningUrdu:
                'یہ ایمان کا بنیادی اقرار ہے جو ہر مسلمان پر فرض ہے۔ اس میں ایمان کے چھ بنیادی ارکان شامل ہیں۔',
            keyPointsEnglish: [
              '1. Belief in Allah',
              '2. Belief in Angels',
              '3. Belief in Holy Books',
              '4. Belief in Prophets',
              '5. Belief in the Day of Judgment',
              '6. Belief in Divine Destiny',
            ],
            keyPointsUrdu: [
              '1. اللہ پر ایمان',
              '2. فرشتوں پر ایمان',
              '3. آسمانی کتابوں پر ایمان',
              '4. رسولوں پر ایمان',
              '5. قیامت کے دن پر ایمان',
              '6. تقدیر (اچھے اور برے) پر ایمان',
            ],
          ),

          SizedBox(height: 20),

          /// Iman e Mufassal
          IslamicContentCard(
            title: 'ایمانِ مفصل (Iman e Mufassal)',
            arabic:
                'آمَنْتُ بِاللّٰهِ كَمَا هُوَ بِأَسْمَائِهِ وَصِفَاتِهِ وَقَبِلْتُ جَمِيعَ أَحْكَامِهِ وَأَرْكَانِهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَالْقَدَرِ خَيْرِهِ وَشَرِّهِ مِنَ اللّٰهِ تَعَالَىٰ وَالْبَعْثِ بَعْدَ الْمَوْتِ',
            transliteration:
                'Aamantu billaahi kamaa huwa bi asmaa\'ihi wa sifaatihi wa qabiltu jamee\'a ahkaamihi wa arkaanihi wa malaa\'ikatihi wa kutubihi wa rusulihi wal yawmil aakhiri wal qadari khayrihi wa sharrihi minallaahi ta\'aala wal ba\'thi ba\'dal mawt',
            translation:
                'I believe in Allah as He is, with His Names and Attributes, and I accept all His commands and pillars, His angels, His books, His messengers, the Last Day, and in destiny — its good and bad are from Allah the Most High, and in resurrection after death.',
            urduTranslation:
                'میں ایمان لایا اللہ پر جیسا کہ وہ اپنی صفات و اسماء کے ساتھ ہے، اور میں نے اس کے تمام احکام اور ارکان کو قبول کیا، اس کے فرشتوں پر، اس کی کتابوں پر، اس کے رسولوں پر، قیامت کے دن پر، تقدیر کے اچھے اور برے پر جو اللہ تعالیٰ کی طرف سے ہے، اور موت کے بعد دوبارہ زندہ ہونے پر۔',
            meaningEnglish:
                'This is the detailed declaration of faith which includes belief in Allah’s names, attributes, and all His commands.',
            meaningUrdu:
                'یہ ایمان کا تفصیلی اقرار ہے جس میں اللہ کے اسماء و صفات اور اس کے تمام احکام کو قبول کرنا شامل ہے۔',
            keyPointsEnglish: [
              'Belief in all of Allah\'s Names & Attributes',
              'Acceptance of all His commands',
              'Belief in angels and their duties',
              'Belief in all revealed scriptures',
              'Respect for all Prophets',
              'Preparation for the Afterlife',
            ],
            keyPointsUrdu: [
              'اللہ کے تمام اسماء و صفات پر ایمان',
              'اللہ کے تمام احکام کی قبولیت',
              'فرشتوں پر ایمان اور ان کے کاموں کا اعتراف',
              'تمام آسمانی کتابوں پر ایمان',
              'تمام رسولوں کا احترام',
              'آخرت کی تیاری',
            ],
          ),
        ],
      ),
    );
  }
}

class IslamicContentCard extends StatelessWidget {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String urduTranslation;
  final String meaningEnglish;
  final String meaningUrdu;
  final List<String> keyPointsEnglish;
  final List<String> keyPointsUrdu;

  const IslamicContentCard({
    super.key,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.urduTranslation,
    required this.meaningEnglish,
    required this.meaningUrdu,
    required this.keyPointsEnglish,
    required this.keyPointsUrdu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 20),

          /// Arabic
          Text(
            arabic,
            style: GoogleFonts.amiri(
              fontSize: 24,
              color: primary,
              fontWeight: FontWeight.w600,
              height: 2.0,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),

          /// Transliteration
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              transliteration,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// English Translation
          Text(
            translation,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          /// Urdu Translation
          Text(
            urduTranslation,
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 14,
              color: AppColors.black54,
              height: 2,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),

          /// Meaning (English + Urdu)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Explanation:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meaningEnglish,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'وضاحت:',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meaningUrdu,
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 14,
              color: AppColors.black54,
              height: 2,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),

          const SizedBox(height: 20),

          /// Key Points (English + Urdu)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Key Points:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...keyPointsEnglish.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  point,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.black54,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'اہم نکات:',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 8),
          ...keyPointsUrdu.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                point,
                textAlign: TextAlign.right,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 14,
                  height: 2,
                  color: AppColors.black54,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
