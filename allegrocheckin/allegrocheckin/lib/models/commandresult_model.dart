import 'dart:convert';

CommandResult userModelFromJson(String str) =>
    CommandResult.fromJson(json.decode(str));

class CommandResult {
  CommandResult({required this.result, required this.message, this.data});

  bool result;
  String message;
  dynamic data;

  factory CommandResult.fromJson(Map<String, dynamic> json) => CommandResult(
      result: json["result"], message: json["message"], data: json["data"]);
}
