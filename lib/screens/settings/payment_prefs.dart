import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPrefs extends StatefulWidget {
  @override
  _PaymentPrefsState createState() => _PaymentPrefsState();
}

class _PaymentPrefsState extends State<PaymentPrefs> {
  bool sendOCS = false;

  Future<bool> getPrefs(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = prefs.getBool(name);
    if (_bool == null) {
      _bool = false;
    }
    print("initial _bool is $_bool");
    return _bool;
  }

  Future<bool> setPrefs(String name, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
    print("_bool is $value");
    return prefs.setBool(name, value);
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefs("sendOCS").then((value) {
      setState(() {
        sendOCS = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Preferences",
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            SwitchListTile(
              value: sendOCS,
              onChanged: (bool value) {
                setState(() {
                  sendOCS = value;
                  setPrefs("sendOCS", value);
                });
              },
              title: Text("Send to Telesur Credit",
                  style: GoogleFonts.nunito(fontSize: 20)),
              subtitle: Text(
                "Sends money to recipient's Telesur Credit instead of mWallet (not recommended)",
                style: GoogleFonts.nunito(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
