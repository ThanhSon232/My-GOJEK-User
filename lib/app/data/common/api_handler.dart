import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

abstract class APIHandlerInterface {
  init();

  Future<Map<String, dynamic>> get(String endpoint, Map<String,dynamic> query);

  Future<Map<String, dynamic>> post(var body, String endpoint);

  Future<void> storeToken(String token);

  Future<String?> getToken();

  Future<void> deleteToken();
}

class APIHandlerImp implements APIHandlerInterface {
  static var host = "https://ubercloneserver.herokuapp.com/";
  static const _storage =  FlutterSecureStorage();
  static final APIHandlerImp _singleton = APIHandlerImp._internal();
  static final client = http.Client();

  APIHandlerImp._internal();

  factory APIHandlerImp(){
    return _singleton;
  }


  Future<Map<String, String>> _buildHeader({bool refreshToken = false}) async {
    String? token = await getToken();

    var baseHeader = {
      HttpHeaders.dateHeader: DateTime.now().millisecondsSinceEpoch.toString(),
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
      "device": "app"
    };
    if (token != "") {
      print("[API] Token: ${token ?? ''}");
      baseHeader[HttpHeaders.authorizationHeader] = "Bearer $token";
    }
    return baseHeader;
  }

  static Uri buildUrlWithQuery(String endpoint, Map<String, dynamic> query) {
    return query.isEmpty
        ? Uri.parse(host + endpoint).replace(queryParameters: query)
        : Uri.parse(host + endpoint);
  }

  @override
  Future<void> deleteToken() async{
    await _storage.delete(key: "token");
  }
  
  @override
  Future<String?> getToken() async{
    return await _storage.read(key: "token");
  }

  @override
  init() {

  }

  @override
  Future<Map<String, dynamic>> post(var body, String endpoint) async {
    http.Response response = await client.post(buildUrl(endpoint), body: body, headers: await _buildHeader());
    return json.decode(response.body);
  }

  @override
  Future<void> storeToken(String token) async{
    await _storage.write(key: "token", value: token);
  }


  static Uri buildUrl(String endpoint) {
    return Uri.parse(host + endpoint);
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, Map<String, dynamic> query) async{
    http.Response response = await client.get(buildUrl(endpoint), headers: await _buildHeader());
    return json.decode(response.body);
  }
}
