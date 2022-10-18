import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:tactibeter/api/api_common.dart';
import 'package:tactibeter/api/login.dart';
import 'package:tactibeter/util/prefs.dart';
import 'package:tactibeter/views/home.dart';
import 'package:tactibeter/views/login.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  Widget build(BuildContext context) {
    _checkForUpdate();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/banner.png'),
            fit: BoxFit.fitWidth,
          )
        ),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 22),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator()
          )
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 2), () async {
      String? sessionId = await Prefs.getSessionId();
      if(sessionId == null) {
        navigateToLogin();
        return;
      }

      Response<Session> response = await Login.checkSession(sessionId);
      if(response.status == -1) {
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Er is iets verkeerd gegaan. Probeer het later opnieuw.")));
        });

        return;
      }

      switch(response.status) {
        case 200:
          navigateToHome(response.value!);
          break;
        case 401:
          navigateToLogin();
          break;
        default:
          Future<void>.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!)));
          });
          break;
      }
    });
  }

  void navigateToHome(Session session) {
    debugPrint("Navigating home");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => HomeView(session: session)));
  }

  void navigateToLogin() {
    debugPrint("Navigating to login");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const LoginView()));
  }

  void _checkForUpdate() {
    if(kReleaseMode) {
      NewVersion newVersion = NewVersion(iOSAppStoreCountry: "NL");
      newVersion.showAlertIfNecessary(context: context);
    }
  }
}