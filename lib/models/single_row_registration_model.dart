// To parse this JSON data, do
//
//     final singleRowRegistrationModel = singleRowRegistrationModelFromJson(jsonString);

import 'dart:convert';

List<SingleRowRegistrationModel> singleRowRegistrationModelFromJson(
        String str) =>
    List<SingleRowRegistrationModel>.from(
        json.decode(str).map((x) => SingleRowRegistrationModel.fromJson(x)));

String singleRowRegistrationModelToJson(
        List<SingleRowRegistrationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleRowRegistrationModel {
  SingleRowRegistrationModel({
    required this.sts,
  });

  int sts;

  factory SingleRowRegistrationModel.fromJson(Map<String, dynamic> json) =>
      SingleRowRegistrationModel(
        sts: json["sts"],
      );

  Map<String, dynamic> toJson() => {
        "sts": sts,
      };
}
