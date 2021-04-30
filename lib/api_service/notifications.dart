import 'dart:convert';
import 'dart:io';

//set firebase token
Future<void> setToken(String token, String username, String bearerTk) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/set/token';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
  String body = "phone=$username&token=$token";
  request.add(utf8.encode(body));

  HttpClientResponse response = await request.close();
  print("set token: " + token + " - " + response.statusCode.toString());
}
