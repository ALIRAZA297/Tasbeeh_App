// class QuranModel {
//   List<Surah> surahs;

//   QuranModel({required this.surahs});

//   factory QuranModel.fromJson(Map<String, dynamic> json) {
//     if (json["data"] is Map<String, dynamic>) {
//       return QuranModel(
//         surahs: (json["data"]["surahs"] as List)
//             .map((x) => Surah.fromJson(x))
//             .toList(),
//       );
//     } else {
//       throw Exception("Invalid data format");
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "data": {
//         "surahs": surahs.map((x) => x.toJson()).toList(),
//       },
//     };
//   }
// }

// class Surah {
//   int number;
//   String name;
//   String englishName;
//   String englishNameTranslation;
//   String revelationType;
//   List<Ayah> ayahs;

//   Surah({
//     required this.number,
//     required this.name,
//     required this.englishName,
//     required this.englishNameTranslation,
//     required this.revelationType,
//     required this.ayahs,
//   });

//   factory Surah.fromJson(Map<String, dynamic> json) {
//     return Surah(
//       number: json["number"],
//       name: json["name"],
//       englishName: json["englishName"],
//       englishNameTranslation: json["englishNameTranslation"],
//       revelationType: json["revelationType"],
//       ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "number": number,
//       "name": name,
//       "englishName": englishName,
//       "englishNameTranslation": englishNameTranslation,
//       "revelationType": revelationType,
//       "ayahs": ayahs.map((x) => x.toJson()).toList(),
//     };
//   }
// }

// class Ayah {
//   int number;
//   String text;
//   int numberInSurah;
//   int juz;
//   int manzil;
//   int page;
//   int ruku;
//   int hizbQuarter;
//   bool? sajda;

//   Ayah({
//     required this.number,
//     required this.text,
//     required this.numberInSurah,
//     required this.juz,
//     required this.manzil,
//     required this.page,
//     required this.ruku,
//     required this.hizbQuarter,
//     this.sajda,
//   });

//   factory Ayah.fromJson(Map<String, dynamic> json) {
//     return Ayah(
//       number: json["number"],
//       text: json["text"],
//       numberInSurah: json["numberInSurah"],
//       juz: json["juz"],
//       manzil: json["manzil"],
//       page: json["page"],
//       ruku: json["ruku"],
//       hizbQuarter: json["hizbQuarter"],
//       sajda: json["sajda"] is bool ? json["sajda"] : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "number": number,
//       "text": text,
//       "numberInSurah": numberInSurah,
//       "juz": juz,
//       "manzil": manzil,
//       "page": page,
//       "ruku": ruku,
//       "hizbQuarter": hizbQuarter,
//       "sajda": sajda,
//     };
//   }
// }


class QuranVerse {
  final String index;
  final String name;
  final Map<String, String> verse;
  final Map<String, String> translationBn;
  final int count;
  final List<QuranJuz> juz;

  QuranVerse({
    required this.index,
    required this.name,
    required this.verse,
    required this.translationBn,
    required this.count,
    required this.juz,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    final List<QuranJuz> juzList = [];
    if (json['juz'] != null) {
      for (final juzJson in json['juz']) {
        juzList.add(QuranJuz.fromJson(juzJson));
      }
    }

    return QuranVerse(
      index: json['index'],
      name: json['name'],
      verse: Map<String, String>.from(json['verse']),
      translationBn: Map<String, String>.from(json['translation_bn']),
      count: json['count'],
      juz: juzList,
    );
  }

  static List<QuranVerse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => QuranVerse.fromJson(item)).toList();
  }
}

class QuranJuz {
  final String index;
  final QuranVerseRange verse;

  QuranJuz({required this.index, required this.verse});

  factory QuranJuz.fromJson(Map<String, dynamic> json) {
    return QuranJuz(
      index: json['index'],
      verse: QuranVerseRange.fromJson(json['verse']),
    );
  }
}

class QuranVerseRange {
  final String start;
  final String end;

  QuranVerseRange({required this.start, required this.end});

  factory QuranVerseRange.fromJson(Map<String, dynamic> json) {
    return QuranVerseRange(
      start: json['start'],
      end: json['end'],
    );
  }
}
