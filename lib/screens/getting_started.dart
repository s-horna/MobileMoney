import 'dart:async';

import 'package:MobileMoney4/api_service/authentication/login.dart';
import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/models/slide.dart';
import 'package:MobileMoney4/models/user.dart';
import 'package:MobileMoney4/screens/authentication/phone_number_screen.dart';
import 'package:MobileMoney4/screens/home.dart';
import 'package:MobileMoney4/screens/settings/security/input_code.dart';
import 'package:MobileMoney4/widgets/slide_dots.dart';
import 'package:MobileMoney4/widgets/slide_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _username = prefs.getString('username');
    final String _password = prefs.getString('password');
    var _user = Provider.of<User>(context, listen: false);
    _user.username = _username;

    if (_username != null && _password != null) {
      await apiLogin(context, _username, _password).then((value) {
        if (value == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushReplacement(createRoute(InputCodeScreen(HomePage())));
          });
        } else {
          Navigator.of(context)
              .pushReplacement(createRoute(PhoneNumberScreen()));
        }
      });
    } else {
      Navigator.of(context).pushReplacement(createRoute(PhoneNumberScreen()));
    }
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(
            message['notification']['title'], message['notification']['body']);
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    Timer(Duration(seconds: 3), () async {
      autoLogin();
    });
    super.initState();
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'MobileMoney',
              style: GoogleFonts.nunito(color: primaryYellow, fontSize: 50),
            ),
            SizedBox(height: 100),
            CircularProgressIndicator(backgroundColor: white)
          ],
        ),
      ),
    );
  }
}

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryBlue,
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    itemCount: slideList.length,
                    itemBuilder: (ctx, i) => SlideItem(i),
                    onPageChanged: _onPageChanged,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < slideList.length; i++)
                              if (i == _currentPage)
                                SlideDots(true)
                              else
                                SlideDots(false)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            CupertinoButton(
                pressedOpacity: 0.5,
                onPressed: () {
                  if (_currentPage < 2) {
                    setState(() {
                      _currentPage++;
                    });
                    _pageController.animateToPage(
                      _currentPage,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    Navigator.of(context)
                        .pushReplacement(createRoute(PhoneNumberScreen()));
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: primaryYellow,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }
}
