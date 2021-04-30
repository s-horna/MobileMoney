import 'package:MobileMoney4/api_service/authentication/login.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    String _pw;
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: primaryBlue,
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('Seems like you already have an account...',
                      style: GoogleFonts.nunito(
                          fontSize: 40, color: primaryYellow)),
                  SizedBox(height: 20),
                  Text(
                    'Please enter your password:',
                    style:
                        GoogleFonts.nunito(fontSize: 20, color: primaryYellow),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 20, color: Colors.grey),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      _pw = value;
                      print(_pw);
                    },
                  ),
                  // InternationalPhoneNumberInput(
                  //   onInputChanged: (value) {
                  //     setState(() {
                  //       pn = value.phoneNumber.replaceAll('+', '');
                  //     });
                  //   },
                  //   maxLength: 7,
                  //   formatInput: false,
                  //   searchBoxDecoration: InputDecoration(
                  //       hintStyle: GoogleFonts.nunito(color: Colors.white)),
                  //   inputDecoration: InputDecoration(
                  //       hintText: 'Phone Number',
                  //       hintStyle: GoogleFonts.nunito(color: Colors.grey[300])),
                  //   selectorGoogleFonts.nunito: GoogleFonts.nunito(color: Colors.white),
                  //   countries: ['SR'],
                  //   GoogleFonts.nunito: GoogleFonts.nunito(color: Colors.white),
                  // )
                ],
              ),
            ),
            CupertinoButton(
              pressedOpacity: 0.5,
              onPressed: () {
                apiLogin(context, _user.username, _pw).then((value) async {
                  if (value == null) {
                    pr.show();
                  } else if (value == true) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('username', _user.username);
                    prefs.setString('password', _pw);
                    pr.hide();
                    Navigator.of(context).pushAndRemoveUntil(
                      createRoute(HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                });
              },
              child: Icon(
                Icons.arrow_forward,
                color: primaryYellow,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
