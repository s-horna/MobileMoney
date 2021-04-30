import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MobileMoney4/api_service/history.dart';
import 'package:provider/provider.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/models/transaction.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:MobileMoney4/api_service/transaction.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/screens/home.dart';

class PendingRequestsScreen extends StatefulWidget {
  @override
  _PendingRequestsScreenState createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  List _listTr;

  @override
  void initState() {
    var _user = Provider.of<User>(context, listen: false);
    getTransactionHistory(_user.username, _user.bearerToken, "9").then((value) {
      setState(() {
        _listTr = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pending Requests",
          style: GoogleFonts.nunito(),
        ),
      ),
      body: Container(
        child: _listTr != null
            ? _listTr.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listTr.length,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = _listTr.elementAt(index);
                      String receiver = transaction.receiver;
                      String sender = transaction.sender;
                      String amount = transaction.amount;
                      String date = timeago.format(transaction.date);
                      String note = transaction.note;
                      return transaction.outgoing
                          ? ExpansionTile(
                              title: Text(
                                "$receiver sent you a request",
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
                                      color: Colors.red[300],
                                    ),
                                  ),
                                  TextSpan(
                                    text: " • $date",
                                    style:
                                        GoogleFonts.nunito(color: Colors.grey),
                                  ),
                                ]),
                              ),
                              trailing: Icon(
                                Icons.request_page_rounded,
                                color: Colors.red[300],
                              ),
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonTheme(
                                        minWidth: 130,
                                        height: 40,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          splashColor: Colors.green[400],
                                          color: Colors.green[200],
                                          onPressed: () {
                                            pr.show();
                                            xp2pResponse(_user.bearerToken,
                                                    transaction.id, "confirm")
                                                .then((value) {
                                              if (value == 200 ||
                                                  value == 201) {
                                                pr.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Transaction succesful!'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              createRoute(
                                                                  HomePage()),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false,
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                pr.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Error'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: Text(
                                            'Confirm',
                                            style: GoogleFonts.nunito(
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 40),
                                      ButtonTheme(
                                        minWidth: 130,
                                        height: 40,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.red[200],
                                          splashColor: Colors.red[400],
                                          onPressed: () {
                                            pr.show();
                                            xp2pResponse(_user.bearerToken,
                                                    transaction.id, "reject")
                                                .then((value) {
                                              if (value == 200 ||
                                                  value == 201) {
                                                pr.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Request rejected'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              createRoute(
                                                                  HomePage()),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false,
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                pr.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Error'),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: Text(
                                            'Reject',
                                            style: GoogleFonts.nunito(
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : ListTile(
                              title: Text(
                                "You sent a request to $sender",
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
                                      color: Colors.green[300],
                                    ),
                                  ),
                                  TextSpan(
                                    text: " • $date",
                                    style:
                                        GoogleFonts.nunito(color: Colors.grey),
                                  ),
                                ]),
                              ),
                              trailing: Icon(
                                Icons.request_page_rounded,
                                color: Colors.green[300],
                              ),
                            );
                    },
                  )
                : Center(
                    child: Text(
                    "No pending requests",
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                    ),
                  ))
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
