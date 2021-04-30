import 'package:MobileMoney4/api_service/authentication/send_sms.dart';
import 'package:MobileMoney4/api_service/authentication/login.dart';
import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/authentication/check_otp_screen.dart';
import 'package:MobileMoney4/screens/authentication/password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  String bearerTk;
  bool loading;
  var txt = TextEditingController();

  Future<void> autoLogin() async {
    loading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _username = prefs.getString('username');
    final String _password = prefs.getString('password');

    if (_username != null && _password != null) {
      await apiLogin(context, _username, _password).then((value) {
        if (value == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    getBearer().then((value) {
      setState(() {
        bearerTk = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    String _pn;
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
                  Text('Hello!',
                      style: GoogleFonts.nunito(
                          fontSize: 40, color: primaryYellow)),
                  SizedBox(height: 20),
                  Text(
                    'Please enter your phone number:',
                    style:
                        GoogleFonts.nunito(fontSize: 20, color: primaryYellow),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      Text(
                        '+597',
                        style: GoogleFonts.nunito(
                            color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(7)
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: GoogleFonts.nunito(
                                fontSize: 20, color: Colors.grey),
                          ),
                          style: GoogleFonts.nunito(
                              color: Colors.white, fontSize: 20),
                          onChanged: (value) {
                            _pn = '597' + value;
                            print(_pn);
                          },
                        ),
                      ),
                    ],
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
              onPressed: bearerTk != null
                  ? () async {
                      print(bearerTk);
                      print(_pn);
                      if (_pn.length == 10) {
                        await sendSMS(_pn, bearerTk, context)
                            .then((value) async {
                          if (value == null) {
                            await pr.show();
                          }
                          if (value == true) {
                            pr.hide();
                            _user.username = _pn;
                            _user.bearerToken = bearerTk;
                            Navigator.of(context)
                                .push(createRoute(CheckOTPScreen()));
                          } else if (value == false) {
                            _user.username = _pn;
                            Navigator.of(context)
                                .push(createRoute(PasswordScreen()));
                          }
                        });
                      }
                    }
                  : null,
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
