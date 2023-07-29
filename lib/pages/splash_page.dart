import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String redirectTo = '/sign-in';

    if (authProvider.user == null) {
      authProvider.me().then((value) => {
            if (value) {redirectTo = '/home'}
          });
    }

    Timer(
      Duration(seconds: 3),
      () => Navigator.pushNamed(context, redirectTo),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Center(
          child: Container(
        width: 130,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/kopi_combi.png',
              // 'assets/image_splash.png',
            ),
          ),
        ),
      )),
    );
  }
}
