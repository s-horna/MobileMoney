import 'package:MobileMoney4/api_service/authentication/send_sms.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/authentication/enroll.dart';
import 'package:MobileMoney4/screens/authentication/phone_number_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class CheckOTPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController txt = new TextEditingController();
    var _user = Provider.of<User>(context);
    String otp = '';
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
                  Text('We have sent you an SMS code',
                      style: GoogleFonts.nunito(
                          fontSize: 40, color: primaryYellow)),
                  SizedBox(height: 20),
                  Text(
                    'Please enter the code:',
                    style:
                        GoogleFonts.nunito(fontSize: 20, color: primaryYellow),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Verification Code',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 20, color: Colors.grey),
                    ),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    onChanged: (value) => otp = value,
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
              onPressed: () async {
                checkOTP(_user.username, _user.bearerToken, otp).then((value) {
                  if (value == 201) {
                    Navigator.pushReplacement(
                        context, createRoute(EnrollPage()));
                  } else if (value == 409) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Wrong PIN'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Close"),
                            )
                          ],
                        );
                      },
                    );
                  } else if (value == 408) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('PIN expired'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                sendSMS(
                                    _user.username, _user.bearerToken, context);
                                Navigator.pop(context);
                              },
                              child: Text("Send Code Again"),
                            )
                          ],
                        );
                      },
                    );
                  } else if (value == 401) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    createRoute(PhoneNumberScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text("Close"),
                            )
                          ],
                        );
                      },
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
