import 'package:flutter/material.dart';

class DuaCategoryModel {
  String name;
  List<DuaModel> duas;
  bool isUserAdded;

  DuaCategoryModel({required this.name, required this.duas, this.isUserAdded = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duas': duas.map((dua) => dua.toJson()).toList(),
      'isUserAdded': isUserAdded,
    };
  }

  factory DuaCategoryModel.fromJson(Map<String, dynamic> json) {
    return DuaCategoryModel(
      name: json['name'],
      duas: (json['duas'] as List).map((dua) => DuaModel.fromJson(dua)).toList(),
      isUserAdded: json['isUserAdded'] ?? false,
    );
  }
}

class DuaModel {
  String title;
  String dua;
  String translationUrdu;
  String translationEnglish;
  IconData icon;
  bool isUserAdded;

  DuaModel({
    required this.title,
    required this.dua,
    required this.translationUrdu,
    required this.translationEnglish,
    required this.icon,
    this.isUserAdded = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dua': dua,
      'translationUrdu': translationUrdu,
      'translationEnglish': translationEnglish,
      'icon': icon.codePoint,
      'isUserAdded': isUserAdded,
    };
  }

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      title: json['title'],
      dua: json['dua'],
      translationUrdu: json['translationUrdu'],
      translationEnglish: json['translationEnglish'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isUserAdded: json['isUserAdded'] ?? false,
    );
  }
}
