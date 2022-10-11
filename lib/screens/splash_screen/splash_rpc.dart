import 'package:flutter/material.dart';
import 'package:rastreabilidade_pec_corte_app/screens/Login/login_page.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash_RPC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 5,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.cyan, Colors.cyanAccent],
        ),
        navigateAfterSeconds: LoginPage(),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logoRpc.png"),
            fit: BoxFit.none,
          ),
        ),
      ),
    ],
  );
}
