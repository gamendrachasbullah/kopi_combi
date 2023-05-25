import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kopi_combi/pages/detail_chat_page.dart';
import 'package:kopi_combi/pages/edit_profile_page.dart';
import 'package:kopi_combi/pages/home/main_page.dart';
import 'package:kopi_combi/pages/product_page.dart';
import 'package:kopi_combi/pages/sign_in_page.dart';
import 'package:kopi_combi/pages/sign_up_page.dart';
import 'package:kopi_combi/pages/splash_page.dart';
import 'package:kopi_combi/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => MainPage(),
        '/detail-chat': (context) => DetailChatPage(),
        '/edit-profile': (context) => EditProfilePage(),
        '/product': (context) => ProductPage(),
      },
    );
  }
}
