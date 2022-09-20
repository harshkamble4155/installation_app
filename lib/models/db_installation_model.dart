// To parse this JSON data, do
//
//     final dbInstallationModel = dbInstallationModelFromJson(jsonString);

import 'dart:convert';

DbInstallationModel dbInstallationModelFromJson(String str) =>
    DbInstallationModel.fromJson(json.decode(str));

String dbInstallationModelToJson(DbInstallationModel data) =>
    json.encode(data.toJson());

class DbInstallationModel {
  DbInstallationModel({
    required this.clientName,
    required this.diameter,
    required this.thickness,
    required this.project,
    required this.specification,
    required this.tpia,
    required this.contractor,
    required this.chainage,
    required this.km,
    required this.section,
    required this.location,
    required this.date,
  });

  String clientName;
  String diameter;
  String thickness;
  String project;
  String specification;
  String tpia;
  String contractor;
  String chainage;
  String km;
  String section;
  String location;
  String date;

  factory DbInstallationModel.fromJson(Map<String, dynamic> json) =>
      DbInstallationModel(
        clientName: json["clientName"],
        diameter: json["diameter"],
        thickness: json["thickness"],
        project: json["project"],
        specification: json["specification"],
        tpia: json["tpia"],
        contractor: json["contractor"],
        chainage: json["chainage"],
        km: json["km"],
        section: json["section"],
        location: json["location"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "clientName": clientName,
        "diameter": diameter,
        "thickness": thickness,
        "project": project,
        "specification": specification,
        "tpia": tpia,
        "contractor": contractor,
        "chainage": chainage,
        "km": km,
        "section": section,
        "location": location,
        "date": date,
      };
}
