import 'dart:convert';

CommandResult userModelFromJson(String str) => CommandResult.fromJson(json.decode(str));

class CommandResult {
  CommandResult({this.result, this.message, this.data, this.token, this.aux});

  bool result;
  String message;
  dynamic data;
  dynamic aux;
  String token;

  factory CommandResult.fromJson(Map<String, dynamic> json) =>
      CommandResult(result: json["result"], message: json["message"], data: json["data"], token: json["token"], aux: json["aux"]);
}
