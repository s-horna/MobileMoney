import 'dart:convert';
import 'dart:io';

Future<String> getMBalance(String username, String bearerTk) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/getMBalance/$username';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers.add(HttpHeaders.contentTypeHeader, "application/json");
  HttpClientResponse response = await request.close();
  String decodedResponse = await response.transform(utf8.decoder).join();
  Map details = json.decode(decodedResponse);
  String nameWBalance = details['nameWithBalance'];
  var splitString = nameWBalance.split(' ');
  String balanceP = splitString[1];
  String balance = balanceP.substring(1, balanceP.length - 1);
  print(balance);
  return balance;
}

Future<String> getOBalance(String username, String bearerTk) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/getOBalance/$username';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers.add(HttpHeaders.contentTypeHeader, "application/json");
  HttpClientResponse response = await request.close();
  String decodedResponse = await response.transform(utf8.decoder).join();
  Map details = await json.decode(decodedResponse);
  List balanceList = await details['balances'];
  Map balanceMap = balanceList[0];
  String balance = balanceMap['amount'];
  print(balance);
  return balance;
}

//TODO - add notes

Future<int> transferBalance(
    String username, String bearerTk, String type, String amount) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/transference';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  request.add(utf8.encode("type=$type&phone=$username&amount=$amount&notes="));
  HttpClientResponse response = await request.close();
  return response.statusCode;
  // if (response.statusCode == 200) {
  //   String decodedResponse = await response.transform(utf8.decoder).join();
  //   Map details = await json.decode(decodedResponse);
  //   Map balanceMap = details['toWallet'];
  //   String nameWBalance = balanceMap['nameWithBalance'];
  //   var splitString = nameWBalance.split(' ');
  //   String balanceP = splitString[1];
  //   String balance = balanceP.substring(1, balanceP.length - 1);
  //   return balance;
  // } else {
  //   return null;
  // }
}
