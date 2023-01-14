import 'package:http/http.dart' as http;
import 'dart:convert';
class ApiReq{
  static http.Client client = http.Client();
  static String host = "192.168.3.17:8000";

  static Future<Map> get(String path) async {
    Uri uri = Uri.http(host, path);
    var response = await client.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse;
  }

  static Future<http.Response> download(String path) async{
    Uri uri = Uri.http(host, "/upload" + path);
    http.Response resp = await client.get(uri);
    return resp;
  }
}