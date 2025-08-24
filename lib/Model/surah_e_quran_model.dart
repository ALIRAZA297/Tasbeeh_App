class Surah {
  String? id;
  String? sura;
  String? aya;
  String? arabicText;
  String? translation;
  String? footnotes;
  String? audioURL;

  Surah({
    this.id,
    this.sura,
    this.aya,
    this.arabicText,
    this.translation,
    this.audioURL,
    this.footnotes,
  });

  Surah.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    sura = json['sura']?.toString();
    aya = json['aya']?.toString();
    arabicText = json['arabic_text'];
    translation = json['translation'];
    footnotes = json['footnotes'];
    audioURL = json['audioURL']; // Already included, will be set by provider
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sura'] = sura;
    data['aya'] = aya;
    data['arabic_text'] = arabicText;
    data['translation'] = translation;
    data['footnotes'] = footnotes;
    data['audioURL'] = audioURL;
    return data;
  }
}
