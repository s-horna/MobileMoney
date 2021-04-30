import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:provider/provider.dart';

Future<String> getBearer() async {
  String credentials = 'Converlogic_API_USER' + ":" + 'C0nv3rl0g1c+++';
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);

  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mobileMoneyIntegration/login';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set(HttpHeaders.authorizationHeader, "Basic $encoded");
  HttpClientResponse response = await request.close();
  String bearerTk = response.headers.value('AuthorizationTk');
  print(bearerTk);
  return bearerTk;
}

Future<bool> apiLogin(
    BuildContext context, String username, String password) async {
  String credentials = username + ":" + password;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);

  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mobileMoneyIntegration/login';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set(HttpHeaders.authorizationHeader, "Basic $encoded");
  request.headers.add(HttpHeaders.contentTypeHeader, "application/json");
  HttpClientResponse response = await request.close();
  String bearerToken = response.headers.value('AuthorizationTk');
  String decodedResponse = await response.transform(utf8.decoder).join();
  Map details = json.decode(decodedResponse);
  Map person = details['person'];
  int statusCode = response.statusCode;
  bool _bool() {
    if (_finalUser(
        details, person, bearerToken, password, statusCode, context)) {
      print('apilogin true');
      return true;
    } else {
      return false;
    }
  }

  print(_bool());
  return _bool();
}

bool _finalUser(Map map, Map person, String bearerToken, String password,
    int statusCode, BuildContext context) {
  var _user = Provider.of<User>(context, listen: false);
  if (statusCode == 201) {
    _user.password = password;
    _user.name = person['name'];
    _user.lastName = person['lastname'];
    _user.email = person['email'];
    _user.bearerToken = bearerToken;
    print('finalUser true');
    return true;
  }
  print('finalUser false');
  return false;
}
