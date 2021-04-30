import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/authentication/phone_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Text(
              "This is your account information. However, you can not change it.",
              style: GoogleFonts.nunito(fontSize: 15),
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //   border: Border.symmetric(
            //     vertical: BorderSide(
            //       width: 0.5,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Phone Number/Username:",
                            style: GoogleFonts.nunito(fontSize: 20)),
                        Expanded(child: Container()),
                        Text(
                          _user.username,
                          style: GoogleFonts.nunito(
                              fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Name:", style: GoogleFonts.nunito(fontSize: 20)),
                        Expanded(child: Container()),
                        Text(
                          "${_user.name} ${_user.lastName}",
                          style: GoogleFonts.nunito(
                              fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Email:", style: GoogleFonts.nunito(fontSize: 20)),
                        Expanded(child: Container()),
                        Text(
                          _user.email,
                          style: GoogleFonts.nunito(
                              fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "Logout",
                    style: GoogleFonts.nunito(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () async {
                    _user.dispose();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      createRoute(PhoneNumberScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
