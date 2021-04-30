import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/screens/settings/account.dart';
import 'package:MobileMoney4/screens/settings/payment_prefs.dart';
import 'package:MobileMoney4/screens/settings/security/input_code.dart';
import 'package:MobileMoney4/screens/settings/security/security.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pending_requests.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "Account",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.push(context, createRoute(AccountPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text(
                      "Payment Preferences",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.push(context, createRoute(PaymentPrefs()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text(
                      "Security",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.push(context,
                          createRoute(InputCodeScreen(SecurityPage())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.request_page),
                    title: Text(
                      "Pending Requests",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.push(
                          context, createRoute(PendingRequestsScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(
                      "Notifications",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text(
                      "Help",
                      style: GoogleFonts.nunito(fontSize: 20),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
