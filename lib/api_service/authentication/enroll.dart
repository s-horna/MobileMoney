import 'dart:io';
import 'dart:convert';

Future<int> enroll(String username, String password, String name,
    String lastName, String email, String bearerTk) async {
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/enroll';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encodedPassword = stringToBase64.encode(password);
  String body =
      "phone=$username&name=$name&lastName=$lastName&encodedPassword=$encodedPassword&email=$email";
  request.add(utf8.encode(body));

  HttpClientResponse response = await request.close();
  print("set token: " + response.statusCode.toString());
  return response.statusCode;
}
