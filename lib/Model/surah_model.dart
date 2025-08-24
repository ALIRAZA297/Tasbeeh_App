
class QuranSurah {
  String place;
  String type;
  int count;
  String title;
  String titleAr;
  String index;
  String pages;
  List<Juz> juz;

  QuranSurah({
    required this.place,
    required this.type,
    required this.count,
    required this.title,
    required this.titleAr,
    required this.index,
    required this.pages,
    required this.juz,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) => QuranSurah(
        place: json["place"],
        type: json["type"],
        count: json["count"],
        title: json["title"],
        titleAr: json["titleAr"],
        index: json["index"],
        pages: json["pages"],
        juz: List<Juz>.from(json["juz"].map((x) => Juz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "place": place,
        "type": type,
        "count": count,
        "title": title,
        "titleAr": titleAr,
        "index": index,
        "pages": pages,
        "juz": List<dynamic>.from(juz.map((x) => x.toJson())),
      };

  static List<QuranSurah> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => QuranSurah.fromJson(item)).toList();
  }
}

class Juz {
  String index;
  Verse verse;

  Juz({
    required this.index,
    required this.verse,
  });

  factory Juz.fromJson(Map<String, dynamic> json) => Juz(
        index: json["index"],
        verse: Verse.fromJson(json["verse"]),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "verse": verse.toJson(),
      };
}

class Verse {
  String start;
  String end;

  Verse({
    required this.start,
    required this.end,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}
