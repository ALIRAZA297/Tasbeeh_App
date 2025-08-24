class FavoriteSurah {
  final int index;
  final String title;
  final String titleAr;
  final String place;
  final int count;
  final DateTime addedAt;

  FavoriteSurah({
    required this.index,
    required this.title,
    required this.titleAr,
    required this.place,
    required this.count,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'title': title,
    'titleAr': titleAr,
    'place': place,
    'count': count,
    'addedAt': addedAt.millisecondsSinceEpoch,
  };

  factory FavoriteSurah.fromJson(Map<String, dynamic> json) => FavoriteSurah(
    index: json['index'],
    title: json['title'],
    titleAr: json['titleAr'],
    place: json['place'],
    count: json['count'],
    addedAt: DateTime.fromMillisecondsSinceEpoch(json['addedAt']),
  );
}
