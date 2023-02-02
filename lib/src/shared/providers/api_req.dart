import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/settings.dart';
import '../classes/classes.dart';
class ApiReq{
  static http.Client client = http.Client();
  static String host = API_HOST;

  static Future<Map> get(String path) async {
    Uri uri = Uri.http(host, path);
    var response = await client.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse;
  }

  static Future<String> sendSmsCode(String mobile) async {
    Uri uri = Uri.http(host, "/api/send_sms_code");
    var response = await client.post(uri,
        body: <String, String>{"mobile": mobile},
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse["result"];
  }

  static Future<bool> checkIsFavourite({required User user, required int lesson_id}) async {
    Uri uri = Uri.http(host, "/api/lessons/check_favourite/" + lesson_id.toString());
    Map<String, String> header = {"Authorization": "Token " + user.token};
    var response = await client.get(uri, headers: header);
    return jsonDecode(utf8.decode(response.bodyBytes))["result"] as bool;
  }

  static Future<void> addToFavourite({required User user, required int lesson_id}) async {
    Uri uri = Uri.http(host, "/api/lessons/add_to_favourite");
    Map<String, String> header = {"Authorization": "Token " + user.token};
    await client.post(uri, headers: header, body: {"lesson_id": lesson_id.toString()});
  }

  static Future<void> removeFavourite({required User user, required int lesson_id}) async {
    Uri uri = Uri.http(host, "/api/lessons/remove_favourite");
    Map<String, String> header = {"Authorization": "Token " + user.token};
    await client.post(uri, headers: header, body: {"lesson_id": lesson_id.toString()});
  }

  static Future<List> getList(String path, {String? token}) async {
    Map<String, String> header = {};
    if(token != null){
      header["Authorization"] = "Token " + token;
    }
    Uri uri = Uri.http(host, path);
    var response = await client.get(uri, headers: header);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))["result"] as List;
    return decodedResponse;
  }

  static Future<http.Response> download(String path) async{
    Uri uri = Uri.http(host, "/upload" + path);
    http.Response resp = await client.get(uri);
    return resp;
  }
  
  static Future<Map> getLabelLessonsHome() async {
    Uri uri = Uri.http(host, "/api/label_lessons_home");
    var response = await client.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse["result"] as Map;
  }

  static Future<List<Lesson>> getLabelLessons(String labelId) async {
    Uri uri = Uri.http(host, "/api/label_lessons/" + labelId);
    var response = await client.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var lessons = decodedResponse["result"] as List<Map>;
    return lessons.map((e) => Lesson.fromMap(e)).toList();
  }

  static Future<Map<String, dynamic>> register(Map<String, String> data) async {
    var uri = Uri.http(host, "/api/register");
    var response = await http.post(
        uri,
        body: data,
    // headers: {'Content-Type':'application/json'}
    );
    return json.decode(response.body);
  }

  static Uri loginUri(){
    return Uri.http(host, "/api/login");
  }
}