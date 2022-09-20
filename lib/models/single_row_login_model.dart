import 'dart:convert';

SingleRowLoginModel singleRowLoginModelFromJson(String str) =>
    SingleRowLoginModel.fromJson(json.decode(str));

String singleRowLoginModelToJson(SingleRowLoginModel data) =>
    json.encode(data.toJson());

class SingleRowLoginModel {
  SingleRowLoginModel({
    required this.userDetails,
  });

  List<UserDetail> userDetails;

  factory SingleRowLoginModel.fromJson(Map<String, dynamic> json) =>
      SingleRowLoginModel(
        userDetails: List<UserDetail>.from(
            json["userDetails_data"].map((x) => UserDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userDetails_data":
            List<dynamic>.from(userDetails.map((x) => x.toJson())),
      };
}

class UserDetail {
  UserDetail({
    required this.sts,
    required this.username,
    required this.password,
    required this.ime_num,
  });

  int sts;
  String username;
  String password;
  String ime_num;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        sts: json["sts"],
        username: json["username"],
        password: json["password"],
        ime_num: json["ime_num"],
      );

  Map<String, dynamic> toJson() => {
        "sts": sts,
        "username": username,
        "password": password,
        "ime_num": ime_num,
      };
}
