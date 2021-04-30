import 'package:MobileMoney4/api_service/balance.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class TransferBalanceScreen extends StatefulWidget {
  @override
  _TransferBalanceScreenState createState() => _TransferBalanceScreenState();
}

class _TransferBalanceScreenState extends State<TransferBalanceScreen> {
  bool isW2W = true;
  @override
  Widget build(BuildContext context) {
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    var _user = Provider.of<User>(context);
    TextEditingController numTxt = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer between wallets',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Amount:',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 100,
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
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '0',
                          labelStyle: GoogleFonts.nunito(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "SRD",
                    style: GoogleFonts.nunito(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                border:
                    Border.symmetric(vertical: BorderSide(color: Colors.grey))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transference Type:',
                    style: GoogleFonts.nunito(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RadioListTile(
                    title: Text(
                      'mWallet to Telesur Credit',
                      style:
                          GoogleFonts.nunito(fontSize: 15, color: Colors.black),
                    ),
                    value: true,
                    groupValue: isW2W,
                    onChanged: (T) {
                      setState(() {
                        isW2W = T;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      'Telesur Credit to mWallet',
                      style:
                          GoogleFonts.nunito(fontSize: 15, color: Colors.black),
                    ),
                    value: false,
                    groupValue: isW2W,
                    onChanged: (T) {
                      setState(() {
                        isW2W = T;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Container(
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
                      transferBalance(_user.username, _user.bearerToken,
                              isW2W ? 'w2o' : 'o2w', numTxt.text)
                          .then((value) {
                        if (value == 201) {
                          pr.hide();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Success!"),
                                content: Text(
                                    "Your transaction was successfully completed."),
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
                                    'Your transaction could not be completed. Make sure you have enough funds.'),
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
                    'Send',
                    style: GoogleFonts.nunito(fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
