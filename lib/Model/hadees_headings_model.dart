class HadithHeading {
  final int chapterId;
  final String headingEnglish;
  final String headingUrdu;
  final String headingArabic;

  HadithHeading({
    required this.chapterId,
    required this.headingEnglish,
    required this.headingUrdu,
    required this.headingArabic,
  });

  factory HadithHeading.fromJson(Map<String, dynamic> json) {
    return HadithHeading(
      chapterId: int.parse(json["chapterId"]),
      headingEnglish: json["headingEnglish"],
      headingUrdu: json["headingUrdu"],
      headingArabic: json["headingArabic"],
    );
  }
}

class HadithHeadingsResponse {
  final List<HadithHeading> headings;

  HadithHeadingsResponse({required this.headings});

  factory HadithHeadingsResponse.fromJson(Map<String, dynamic> json) {
    return HadithHeadingsResponse(
      headings: List<HadithHeading>.from(json["hadiths"]["data"].map((x) => HadithHeading.fromJson(x))),
    );
  }
}
