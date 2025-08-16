class AudioModel {
  String index;
  String name;
  Map<String, String> audios;

  AudioModel({
    required this.index,
    required this.name,
    required this.audios,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
        index: json["index"],
        name: json["name"],
        audios: Map.from(json["audios"]).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "name": name,
        "audios": Map.from(audios).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
  static List<AudioModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => AudioModel.fromJson(item)).toList();
  }
}
