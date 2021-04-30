import 'package:MobileMoney4/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetCodeScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    bool hasError;
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Code', style: GoogleFonts.nunito()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Create a PIN code',
                style: GoogleFonts.nunito(fontSize: 30),
              )),
          Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            child: PinCodeTextField(
              controller: controller,
              maskCharacter: "*",
              hideCharacter: true,
              pinTextStyle: GoogleFonts.nunito(fontSize: 15),
              onDone: (text) {
                Navigator.push(
                    context, createRoute(ConfirmCodeScreen(controller.text)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmCodeScreen extends StatefulWidget {
  final String initialCode;
  ConfirmCodeScreen(this.initialCode);
  @override
  _ConfirmCodeScreenState createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  final TextEditingController controller = TextEditingController(text: '');
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Code",
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Confirm PIN code',
                style: GoogleFonts.nunito(fontSize: 30),
              )),
          Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            child: PinCodeTextField(
              controller: controller,
              maskCharacter: "*",
              hasError: hasError,
              hideCharacter: true,
              pinTextStyle: GoogleFonts.nunito(fontSize: 15),
              onDone: (text) async {
                if (text.isEmpty || text == '' || text != widget.initialCode) {
                  hasError = true;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Wrong PIN",
                          style: GoogleFonts.nunito(),
                        ),
                        content: Text("Please input the same PIN"),
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
                } else if (text == widget.initialCode) {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("PIN", text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
