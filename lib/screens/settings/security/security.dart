import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/screens/settings/security/set_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool useCode = false;
  bool useFingerprint = false;
  Future<bool> getPrefs(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = prefs.getBool(name);
    if (_bool == null) {
      _bool = false;
    }
    print("initial _bool is $_bool");
    return _bool;
  }

  Future<bool> getPrefsString(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _string = prefs.getString(name);
    bool _bool = false;
    if (_string != null) {
      _bool = true;
    }
    print("string $_bool");
    return _bool;
  }

  Future<bool> setPrefs(String name, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
    print("_bool is $value");
    return prefs.setBool(name, value);
  }

  Future<bool> removePrefs(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
    print("removed");
    var _var = prefs.get(name);
    if (_var != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefsString("PIN").then((value) {
      setState(() {
        useCode = value;
      });
    });
    getPrefs("useFingerprint").then((value) {
      setState(() {
        useFingerprint = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Security",
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            SwitchListTile(
              value: useCode,
              onChanged: (bool value) {
                setState(() {
                  if (value) {
                    Navigator.push(context, createRoute(SetCodeScreen()));
                  } else {
                    setState(() {
                      useCode = value;
                    });
                    removePrefs("PIN");
                  }
                });
              },
              title: Text(
                "Enable Code",
                style: GoogleFonts.nunito(
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                "Set and use PIN code",
                style: GoogleFonts.nunito(fontSize: 15),
              ),
            ),
            // SwitchListTile(
            //   value: useFingerprint,
            //   onChanged: (bool value) {
            //     setState(() {
            //       useFingerprint = value;
            //       setPrefs("useFingerprint", value);
            //     });
            //   },
            //   title: Text(
            //     "Enable Fingerprint Security",
            //     style: GoogleFonts.nunito(
            //       fontSize: 20,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
