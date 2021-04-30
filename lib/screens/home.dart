import 'dart:async';

import 'package:MobileMoney4/api_service/balance.dart';
import 'package:MobileMoney4/api_service/history.dart';
import 'package:MobileMoney4/api_service/notifications.dart';
import 'package:MobileMoney4/models/transaction.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/payment/pay_contact.dart';
import 'package:MobileMoney4/screens/request/request_contact.dart';
import 'package:MobileMoney4/screens/settings/settings.dart';
import 'package:MobileMoney4/screens/transfer_balance.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  String mBalance;
  String oBalance;
  List _listTr;

  void refresh() {
    setState(() {
      mBalance = null;
      oBalance = null;
      _listTr = null;
    });
    var _user = Provider.of<User>(context, listen: false);
    getMBalance(_user.username, _user.bearerToken).then((value) {
      setState(() {
        mBalance = value;
        _user.mBalance = mBalance;
      });
    });
    getOBalance(_user.username, _user.bearerToken).then((value) {
      setState(() {
        oBalance = value;
        _user.oBalance = oBalance;
      });
    });
    getTransactionHistory(_user.username, _user.bearerToken, "6").then((value) {
      setState(() {
        _listTr = value;
      });
    });
  }

  @override
  void initState() {
    scheduleMicrotask(() async {
      var _user = Provider.of<User>(context, listen: false);
      getMBalance(_user.username, _user.bearerToken).then((value) {
        setState(() {
          mBalance = value;
          _user.mBalance = mBalance;
        });
      });
      getOBalance(_user.username, _user.bearerToken).then((value) {
        setState(() {
          oBalance = value;
          _user.oBalance = oBalance;
        });
      });
      getTransactionHistory(_user.username, _user.bearerToken, "6")
          .then((value) {
        setState(() {
          _listTr = value;
        });
      });
      setToken(await _fcm.getToken(), _user.username, _user.bearerToken);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    var _name = _user.name;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: white,
            ),
            onPressed: () => refresh(),
          ),
          IconButton(
              icon: Icon(
                Icons.menu,
                color: white,
              ),
              onPressed: () {
                Navigator.push(context, createRoute(SettingsPage()));
              })
        ],
        title: Text(
          'Hello $_name!',
          style: GoogleFonts.nunito(color: white),
        ),
        elevation: 2,
        backgroundColor: primaryBlue,
      ),
      backgroundColor: white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  height: 220,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 7,
                        spreadRadius: 5,
                        offset: Offset(0, 1),
                      )
                    ],
                    color: primaryBlue,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "\nmBalance\n",
                          style: GoogleFonts.nunito(
                              color: white.withOpacity(0.5), fontSize: 18)),
                      mBalance == null
                          ? TextSpan(
                              text: "loading...",
                              style: GoogleFonts.nunito(
                                color: white,
                                fontSize: 36,
                              ))
                          : TextSpan(
                              text: "$mBalance ",
                              style: GoogleFonts.nunito(
                                  color: white, fontSize: 36)),
                      TextSpan(
                          text: "SRD \n",
                          style: GoogleFonts.nunito(
                              color: white.withOpacity(0.5), fontSize: 30)),
                      TextSpan(
                          text: " \nTelesur Credit\n",
                          style: GoogleFonts.nunito(
                              color: white.withOpacity(0.5), fontSize: 18)),
                      oBalance == null
                          ? TextSpan(
                              text: "loading...",
                              style: GoogleFonts.nunito(
                                color: white,
                                fontSize: 36,
                              ))
                          : TextSpan(
                              text: "$oBalance ",
                              style: GoogleFonts.nunito(
                                  color: white, fontSize: 36)),
                      TextSpan(
                          text: "SRD \n",
                          style: GoogleFonts.nunito(
                              color: white.withOpacity(0.5), fontSize: 30)),
                    ])),
                    IconButton(
                        icon: Icon(
                          Icons.swap_vert,
                          color: white,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, createRoute(TransferBalanceScreen()));
                        })
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _listTr == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listTr.length,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = _listTr.elementAt(index);
                      String receiver = transaction.receiver;
                      String sender = transaction.sender;
                      String amount = transaction.amount;
                      String date = timeago.format(transaction.date);
                      String note = transaction.note;
                      return Container(
                        height: 80,
                        child: Center(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 18),
                            leading: Icon(
                              Icons.send,
                              color: transaction.outgoing
                                  ? Colors.red[300]
                                  : Colors.green[300],
                              textDirection: transaction.outgoing
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                            ),
                            title: Text(
                              transaction.outgoing
                                  ? "Payment to $receiver"
                                  : "$sender paid you",
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: '$amount SRD',
                                style: GoogleFonts.nunito(
                                  color: transaction.outgoing
                                      ? Colors.red[300]
                                      : Colors.green[300],
                                ),
                              ),
                              TextSpan(
                                text: " • $date",
                                style: GoogleFonts.nunito(color: Colors.grey),
                              ),
                              note != null && note.isNotEmpty
                                  ? TextSpan(
                                      text: "\n$note",
                                      style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    )
                                  : TextSpan()
                            ])),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(color: Colors.grey))),
                      );
                    },
                  ),
          ),
          Container(
            alignment: Alignment.center,
            height: 80,
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 150,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    splashColor: Colors.grey[400],
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).push(createRoute(RequestContact()));
                    },
                    child: Text(
                      'Request',
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(width: 40),
                ButtonTheme(
                  minWidth: 150,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).push(createRoute(PaymentContact()));
                    },
                    child:
                        Text('Send', style: GoogleFonts.nunito(fontSize: 20)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
