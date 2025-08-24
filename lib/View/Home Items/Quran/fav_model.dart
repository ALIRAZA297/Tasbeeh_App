class FavoriteAyat {
  final int surahNumber;
  final String surahNameAr;
  final String surahNameEng;
  final int ayatNumber;
  final String arabicText;
  final String translation;
  final String language;
  final DateTime addedAt;

  FavoriteAyat({
    required this.surahNumber,
    required this.surahNameAr,
    required this.surahNameEng,
    required this.ayatNumber,
    required this.arabicText,
    required this.translation,
    required this.language,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'surahNumber': surahNumber,
    'surahNameAr': surahNameAr,
    'surahNameEng': surahNameEng,
    'ayatNumber': ayatNumber,
    'arabicText': arabicText,
    'translation': translation,
    'language': language,
    'addedAt': addedAt.millisecondsSinceEpoch,
  };

  factory FavoriteAyat.fromJson(Map<String, dynamic> json) => FavoriteAyat(
    surahNumber: json['surahNumber'],
    surahNameAr: json['surahNameAr'],
    surahNameEng: json['surahNameEng'],
    ayatNumber: json['ayatNumber'],
    arabicText: json['arabicText'],
    translation: json['translation'],
    language: json['language'],
    addedAt: DateTime.fromMillisecondsSinceEpoch(json['addedAt']),
  );

  // Create unique key for ayat
  String get uniqueKey => '${surahNumber}_${ayatNumber}_$language';
}
