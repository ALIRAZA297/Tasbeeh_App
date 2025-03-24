class Hadith {
  final int id;
  final String hadithNumber;
  final String hadithEnglish;
  final String hadithUrdu;
  final String hadithArabic;
  final String headingEnglish;
  final String headingUrdu;
  final String headingArabic;
  final String bookSlug;
  final int chapterId;

  Hadith({
    required this.id,
    required this.hadithNumber,
    required this.hadithEnglish,
    required this.hadithUrdu,
    required this.hadithArabic,
    required this.headingEnglish,
    required this.headingUrdu,
    required this.headingArabic,
    required this.bookSlug,
    required this.chapterId,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json["id"] ?? 0,
      hadithNumber: json["hadithNumber"] ?? "N/A",
      hadithEnglish: json["hadithEnglish"] ?? "Hadith text not available",
      hadithUrdu: json["hadithUrdu"] ?? "حدیث دستیاب نہیں ہے",
      hadithArabic: json["hadithArabic"] ?? "الحديث غير متوفر",
      headingEnglish: json["headingEnglish"] ?? "No heading available",
      headingUrdu: json["headingUrdu"] ?? "کوئی عنوان دستیاب نہیں ہے",
      headingArabic: json["headingArabic"] ?? "لا يوجد عنوان",
      bookSlug: json["bookSlug"] ?? "unknown",
      chapterId: int.tryParse(json["chapterId"]?.toString() ?? "0") ?? 0,
    );
  }
}

class HadithResponse {
  final List<Hadith> hadiths;
  final int currentPage;
  final int totalPages;

  HadithResponse({
    required this.hadiths,
    required this.currentPage,
    required this.totalPages,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    return HadithResponse(
      hadiths: List<Hadith>.from(
          json["hadiths"]["data"].map((x) => Hadith.fromJson(x))),
      currentPage: json["hadiths"]["current_page"] ?? 1,
      totalPages: json["hadiths"]["last_page"] ?? 1,
    );
  }
}
