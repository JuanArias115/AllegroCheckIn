import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel(
      {this.id,
      this.email,
      this.password,
      this.username,
      this.role,
      this.createdDate,
      this.active,
      this.pictureUrl,
      this.birthDate,
      this.phone,
      this.identification,
      this.languageId,
      this.emailAddress,
      this.membership,
      this.membershipId,
      this.referredUsers,
      this.membershipEndDate,
      this.membershipDelete,
      this.country,
      this.testingDate,
      this.age,
      this.lastname});

  int id;
  String email;
  String password;
  String username;
  String lastname;
  String role;
  String createdDate;
  bool active;
  String pictureUrl;
  String birthDate;
  String phone;
  String identification;
  int languageId;
  String emailAddress;
  String membership;
  String membershipEndDate;
  int membershipId;
  int referredUsers;
  bool membershipDelete;
  String country;
  bool testingDate;
  int age;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      username: json["username"],
      role: json["role"],
      createdDate: json["createdDate"],
      active: json["active"],
      pictureUrl: json["pictureUrl"],
      phone: json["phone"],
      identification: json["identification"],
      birthDate: json["birthDate"] != null ? json["birthDate"] : null,
      languageId: json["languageId"],
      emailAddress: json["emailAddress"],
      membership: json["membership"],
      membershipId: json["membershipId"],
      referredUsers: json["referredUsers"],
      membershipEndDate: json["membershipEndDate"],
      membershipDelete: json["membershipDelete"],
      country: json["country"],
      testingDate: json["testingDate"],
      age: json["age"],
      lastname: json["lastname"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "username": username,
        "role": role,
        "createdDate": createdDate,
        "active": active,
        "pictureUrl": pictureUrl,
        "identification": identification,
        "birthDate": birthDate,
        "phone": phone,
        "languageId": languageId,
        "emailAddress": emailAddress,
        "membership": membership,
        "membershipId": membershipId,
        "referredUsers": referredUsers,
        "membershipEndDate": membershipEndDate,
        "membershipDelete": membershipDelete,
        "country": country,
        "testingDate": testingDate,
        "age": age,
        "lastname": lastname
      };
}
