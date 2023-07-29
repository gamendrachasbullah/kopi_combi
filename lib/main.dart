import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kopi_combi/pages/detail_chat_page.dart';
import 'package:kopi_combi/pages/edit_password_page.dart';
import 'package:kopi_combi/pages/edit_profile_page.dart';
// import 'package:kopi_combi/pages/home/checkout_page.dart';
import 'package:kopi_combi/pages/home/main_page.dart';
import 'package:kopi_combi/pages/product_page.dart';
import 'package:kopi_combi/pages/sign_in_page.dart';
import 'package:kopi_combi/pages/sign_up_page.dart';
import 'package:kopi_combi/pages/splash_page.dart';
import 'package:kopi_combi/pages/transaction_page.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/providers/product.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => SplashPage(),
            '/sign-in': (context) => SignInPage(),
            '/sign-up': (context) => SignUpPage(),
            '/home': (context) => MainPage(
                  currentIndex:
                      ModalRoute.of(context)?.settings.arguments == null
                          ? 0
                          : 1,
                ),
            '/detail-chat': (context) => DetailChatPage(),
            // '/checkout': (context) => CheckoutPage(),
            '/edit-profile': (context) => EditProfilePage(),
            '/edit-password': (context) => EditPasswordPage(),
            '/transaction': (context) => TransactionPage(),
            '/product': (context) => ProductPage(
                productId: ModalRoute.of(context)!.settings.arguments as int),
          },
        ));
  }
}
