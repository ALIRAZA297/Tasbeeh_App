class HadithBook {
  final int id;
  final String bookName;
  final String writerName;
  final String? aboutWriter;
  final String writerDeath;
  final String bookSlug;
  final int hadithsCount;
  final int chaptersCount;

  HadithBook({
    required this.id,
    required this.bookName,
    required this.writerName,
    this.aboutWriter,
    required this.writerDeath,
    required this.bookSlug,
    required this.hadithsCount,
    required this.chaptersCount,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json["id"],
      bookName: json["bookName"],
      writerName: json["writerName"],
      aboutWriter: json["aboutWriter"],
      writerDeath: json["writerDeath"],
      bookSlug: json["bookSlug"],
      hadithsCount: int.tryParse(json["hadiths_count"] ?? "0") ?? 0,
      chaptersCount: int.tryParse(json["chapters_count"] ?? "0") ?? 0,
    );
  }
}

class HadithBooksResponse {
  final List<HadithBook> books;

  HadithBooksResponse({required this.books});

  factory HadithBooksResponse.fromJson(Map<String, dynamic> json) {
    return HadithBooksResponse(
      books: List<HadithBook>.from(json["books"].map((x) => HadithBook.fromJson(x))),
    );
  }
}
