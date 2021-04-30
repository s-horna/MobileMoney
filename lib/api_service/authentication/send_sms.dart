import 'dart:convert';
import 'dart:io';
import 'package:MobileMoney4/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> sendSMS(String pn, String bearerTk, BuildContext context) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/sendSMS';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.add('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  String str = "phone=$pn";
  request.add(utf8.encode(str));
  HttpClientResponse response = await request.close();

  var _user = Provider.of<User>(context, listen: false);
  _user.bearerToken = response.headers.value("AuthorizationTk");

  int statusCode = response.statusCode;
  print(statusCode);
  if (statusCode == 201) {
    return true;
  } else if (statusCode == 410) {
    return false;
  } else {
    return null;
  }
}

Future<int> checkOTP(String pn, String bearerTk, String otp) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/checkOTP';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.add('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  request.add(utf8.encode("phone=$pn&otp=$otp"));
  HttpClientResponse response = await request.close();
  int statusCode = response.statusCode;
  print(statusCode);
  print(otp);
  return statusCode;
}
