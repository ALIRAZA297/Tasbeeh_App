class HadithChapter {
  final int id;
  final String chapterNumber;
  final String chapterEnglish;
  final String chapterUrdu;
  final String chapterArabic;
  final String bookSlug;

  HadithChapter({
    required this.id,
    required this.chapterNumber,
    required this.chapterEnglish,
    required this.chapterUrdu,
    required this.chapterArabic,
    required this.bookSlug,
  });

  factory HadithChapter.fromJson(Map<String, dynamic> json) {
    return HadithChapter(
      id: json["id"],
      chapterNumber: json["chapterNumber"],
      chapterEnglish: json["chapterEnglish"],
      chapterUrdu: json["chapterUrdu"],
      chapterArabic: json["chapterArabic"],
      bookSlug: json["bookSlug"],
    );
  }
}

class HadithChaptersResponse {
  final List<HadithChapter> chapters;

  HadithChaptersResponse({required this.chapters});

  factory HadithChaptersResponse.fromJson(Map<String, dynamic> json) {
    return HadithChaptersResponse(
      chapters: List<HadithChapter>.from(json["chapters"].map((x) => HadithChapter.fromJson(x))),
    );
  }
}
