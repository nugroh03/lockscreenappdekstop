// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) =>
    SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  SettingModel({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.image,
  });

  String text1;
  String text2;
  String text3;
  String image;

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        text1: json["text1"],
        text2: json["text2"],
        text3: json["text3"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text1": text1,
        "text2": text2,
        "text3": text3,
        "image": image,
      };
}
