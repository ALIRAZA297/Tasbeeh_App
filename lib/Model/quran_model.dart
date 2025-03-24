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
// }

class QuranModel {
  List<Surah> surahs;

  QuranModel({required this.surahs});

  factory QuranModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map<String, dynamic>) {
      return QuranModel(
        surahs: (json["data"]["surahs"] as List)
            .map((x) => Surah.fromJson(x))
            .toList(),
      );
    } else {
      throw Exception("Invalid data format");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "surahs": surahs.map((x) => x.toJson()).toList(),
      },
    };
  }
}

class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json["number"],
      name: json["name"],
      englishName: json["englishName"],
      englishNameTranslation: json["englishNameTranslation"],
      revelationType: json["revelationType"],
      ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "name": name,
      "englishName": englishName,
      "englishNameTranslation": englishNameTranslation,
      "revelationType": revelationType,
      "ayahs": ayahs.map((x) => x.toJson()).toList(),
    };
  }
}

class Ayah {
  int number;
  String text;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;
  bool? sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json["number"],
      text: json["text"],
      numberInSurah: json["numberInSurah"],
      juz: json["juz"],
      manzil: json["manzil"],
      page: json["page"],
      ruku: json["ruku"],
      hizbQuarter: json["hizbQuarter"],
      sajda: json["sajda"] is bool ? json["sajda"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "text": text,
      "numberInSurah": numberInSurah,
      "juz": juz,
      "manzil": manzil,
      "page": page,
      "ruku": ruku,
      "hizbQuarter": hizbQuarter,
      "sajda": sajda,
    };
  }
}
