import 'package:MobileMoney4/api_service/transaction.dart';
import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/home.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestScreen extends StatefulWidget {
  final String phoneNumber;
  final Contact contact;
  RequestScreen({this.contact, this.phoneNumber});
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isMWallet = true;
  bool isExpanded = false;
  TextEditingController numTxt = new TextEditingController();
  TextEditingController noteTxt = new TextEditingController();
  Future<bool> getPrefs(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = prefs.getBool(name);
    if (_bool == null) {
      _bool = false;
    }
    print("initial _bool is $_bool");
    return _bool;
  }

  @override
  void initState() {
    if (widget.phoneNumber == null && widget.contact == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Invalid contact/phone number'),
              content: Text('Choose a valid contact/phone number'),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
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
          'Request',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            // decoration: BoxDecoration(
            //     border:
            //         Border.symmetric(vertical: BorderSide(color: Colors.grey))),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'To: ',
                            style: GoogleFonts.nunito(
                                color: Colors.black, fontSize: 20)),
                        TextSpan(
                          text: widget.contact != null
                              ? widget.contact.displayName
                              : widget.phoneNumber,
                          style: GoogleFonts.nunito(
                              color: primaryBlue, fontSize: 20),
                        )
                      ]))),
                  flex: 6,
                ),
                Expanded(
                  child: TextFormField(
                    controller: numTxt,
                    autofocus: true,
                    style: GoogleFonts.nunito(fontSize: 20),
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.center,
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: '0',
                      labelStyle: GoogleFonts.nunito(color: Colors.grey),
                    ),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Text(
                      'SRD',
                      style: GoogleFonts.nunito(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: noteTxt,
                    maxLines: 1,
                    style: GoogleFonts.nunito(fontSize: 20),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Note (optional)',
                      labelStyle: GoogleFonts.nunito(color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: ButtonTheme(
                    height: 50,
                    minWidth: 300,
                    buttonColor: primaryYellow,
                    child: RaisedButton(
                      onPressed: () {
                        if (numTxt.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Please type an amount'),
                                actions: [
                                  FlatButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else if (double.tryParse(numTxt.text) == null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Please type a valid amount'),
                                actions: [
                                  FlatButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          pr.show();
                          String phoneNumber = widget.contact == null
                              ? widget.phoneNumber
                              : returnNumbers(
                                  widget.contact.phones.first.value.toString());
                          String note = noteTxt.text.replaceAll(' ', '_');
                          xp2p(_user.username, _user.bearerToken, phoneNumber,
                                  numTxt.text)
                              .then((value) {
                            if (value == 201) {
                              pr.hide();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Success!"),
                                    content: Text(
                                        "Your request was succesfully processed."),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            createRoute(HomePage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: Text('Done'),
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
                                    content: Text(
                                        'Your request could not be completed. Make sure the recipient has an account.'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        }
                      },
                      child: Text(
                        'Request',
                        style: GoogleFonts.nunito(fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
