import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestService {
  final String _url = "https://aeglamping.com/admin/";

  Future<CommandResult> httpPost(String method, Object obj) async {
    print(json.encode(obj));
    try {
      final response = await http
          .post(Uri.parse('${_url + method}'),
              body: json.encode(obj), encoding: Encoding.getByName("utf-8"))
          .timeout(const Duration(seconds: 80), onTimeout: () {
        return http.Response("TimeOut", 800);
      }).catchError((error) {
        return http.Response("No access", 400);
      });

      if (response.statusCode == 800) {
        return new CommandResult(
            result: false, message: "Check your internet connection.");
      }

      print('HTTPOST : $_url$method Result : ${response.statusCode}');
      return new CommandResult.fromJson(json.decode(response.body));
    } catch (e) {
      return new CommandResult(result: false, message: e.toString());
    }
  }

  Future<CommandResult> httpGet(String method) async {
    try {
      print('${_url + method}');
      final response = await http
          .get(Uri.parse('${_url + method}'))
          .timeout(const Duration(seconds: 80), onTimeout: () {
        return http.Response("TimeOut", 800);
      }).catchError((error) {
        return http.Response("No access", 400);
      });
      if (response.statusCode == 800) {
        return new CommandResult(
            result: false, message: "Check your internet connection.");
      }

      print('HTTPGET : $_url$method Result : ${response.statusCode}');
      return new CommandResult.fromJson(json.decode(response.body));
    } on SocketException {
      return new CommandResult(
          result: false, message: "Check your internet connection");
    } catch (e) {
      return new CommandResult(result: false, message: e.toString());
    }
  }
}
