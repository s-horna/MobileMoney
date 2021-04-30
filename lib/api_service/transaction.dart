import 'dart:io';
import 'dart:convert';

//TODO - add coupon

Future<int> apiP2P(String username, String bearerTk, String recipient,
    String amount, String type, String note) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/transaction';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  request.add(utf8.encode(
      "type=$type&fromPhone=$username&toPhone=$recipient&amount=$amount&coupon=&notes=$note"));
  HttpClientResponse response = await request.close();
  List rawBody = await response.toList();
  print(utf8.decode(rawBody[0]));
  return response.statusCode;
}

Future<int> xp2p(
    String username, String bearerTk, String recipient, String amount) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/transaction/xp2p';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  request.add(
      utf8.encode("phoneFrom=$recipient&phoneTo=$username&amount=$amount"));
  HttpClientResponse response = await request.close();
  return response.statusCode;
}

Future<int> xp2pResponse(
    String bearerTk, String transactionId, String xp2pResponse) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/transaction/xp2pResponse';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  request.add(
      utf8.encode("transactionId=$transactionId&xp2pResponse=$xp2pResponse"));
  HttpClientResponse response = await request.close();
  return response.statusCode;
}
