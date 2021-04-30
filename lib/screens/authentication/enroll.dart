import 'package:MobileMoney4/api_service/authentication/enroll.dart';
import 'package:MobileMoney4/api_service/authentication/login.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MobileMoney4/constants.dart';

import '../home.dart';

class EnrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name;
    String lastName;
    String email;
    String password;
    var _user = Provider.of<User>(context);
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
                  Text('Sign Up',
                      style: GoogleFonts.nunito(
                          fontSize: 40, color: primaryYellow)),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'First name',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 17, color: Colors.grey),
                    ),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Last name',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 17, color: Colors.grey),
                    ),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    onChanged: (value) {
                      lastName = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 17, color: Colors.grey),
                    ),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          GoogleFonts.nunito(fontSize: 17, color: Colors.grey),
                    ),
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ],
              ),
            ),
            CupertinoButton(
              pressedOpacity: 0.5,
              onPressed: () {
                pr.show();
                enroll(_user.username, password, name, lastName, email,
                        _user.bearerToken)
                    .then((value) {
                  if (value == 200 || value == 201) {
                    pr.hide();
                    apiLogin(context, _user.username, password)
                        .then((loginValue) {
                      if (loginValue == true) {
                        Navigator.of(context).pushAndRemoveUntil(
                          createRoute(HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
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
