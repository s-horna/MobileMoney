import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class InputCodeScreen extends StatefulWidget {
  final Widget route;
  InputCodeScreen(this.route);

  @override
  _InputCodeScreenState createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  final TextEditingController controller = TextEditingController(text: '');
  String code;
  Future<String> getCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _string = prefs.getString("PIN");
    return _string;
  }

  @override
  void initState() {
    // TODO: implement initState
    getCode().then((value) {
      setState(() {
        code = value;
      });
      if (value == null) {
        Navigator.pushReplacement(
          context,
          createRoute(widget.route),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasError = false;
    return code != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Input Code",
                style: GoogleFonts.nunito(),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Enter your PIN code',
                      style: GoogleFonts.nunito(fontSize: 30),
                    )),
                Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  child: PinCodeTextField(
                    controller: controller,
                    hasError: hasError,
                    maskCharacter: "*",
                    hideCharacter: true,
                    pinTextStyle: GoogleFonts.nunito(fontSize: 15),
                    onDone: (text) {
                      if (text.isEmpty || text == '' || text != code) {
                        hasError = true;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Wrong PIN",
                                style: GoogleFonts.nunito(),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Close",
                                    style: GoogleFonts.nunito(),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      } else if (text == code) {
                        Navigator.pushReplacement(
                            context, createRoute(widget.route));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
