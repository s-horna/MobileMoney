import 'dart:convert';
import 'dart:io';

import 'package:MobileMoney4/models/transaction.dart';

//TODO - Set filters

Future<List> getTransactionHistory(
    String username, String bearerTk, String type) async {
  // get time and format correctly
  var now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString();
  String day = now.day.toString();
  String hour = now.hour.toString();
  String minute = now.minute.toString();
  List<String> timeList = [month, day, hour, minute];
  String formattedTime = "$year";
  for (int i = 0; i < timeList.length; i++) {
    if (timeList[i].length < 2) {
      formattedTime += "-" + "0" + timeList[i];
    } else {
      formattedTime += "-" + timeList[i];
    }
  }
  print(formattedTime);

  // http request details
  HttpClient client = new HttpClient();
  String url =
      'https://apimobilemoney.converlogic.com/mmFrontIntegration/getTransactionReport';
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('AuthorizationTk', "$bearerTk");
  request.headers.set(HttpHeaders.contentLengthHeader, "161");
  request.headers
      .add(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

  String body =
      "phone=$username&dateStart=2020-01-01-00-00&dateEnd=$formattedTime&phoneFrom=0&phoneTo=0&transactionId=0&transactionType=0&notes=0&limit=20&offset=0&statusId=$type";
  print(body);

  request.add(utf8.encode(body));

  // response
  HttpClientResponse response = await request.close();
  String decodedResponse = await response.transform(utf8.decoder).join();
  List _list = json.decode(decodedResponse);
  List _trList = new List();
  for (int i = 0; i < _list.length; i++) {
    Transaction _tr = new Transaction();
    Map _trMap = _list[i];
    _tr.amount = _trMap['amount'].toString();
    String dateRaw = _trMap['date'];
    _tr.date = DateTime.parse(dateRaw);
    _tr.id = _trMap['idTransaction'].toString();
    _tr.sender = _trMap['fromName'];
    _tr.receiver = _trMap['toName'];
    if (_trMap['description'].toString().indexOf(":") > 0) {
      _tr.note = _trMap['description']
          .toString()
          .substring(_trMap['description'].toString().indexOf(":") + 2);
    }
    if (_tr.sender == username) {
      _tr.outgoing = true;
    } else {
      _tr.outgoing = false;
    }
    _trList.add(_tr);
  }
  return _trList;
}
