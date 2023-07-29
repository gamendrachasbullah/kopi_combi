import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/theme.dart';
import 'package:provider/provider.dart';

class EditPasswordPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  EditPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Password',
          style: primaryTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .updateProfil(
                          credential: {'password': _passwordController.text});
              if (success && context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.check,
              color: primaryColor,
            ),
          )
        ],
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Password',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: primaryTextStyle,
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText: '8 digit password minimal',
                  hintStyle: primaryTextStyle,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: subtitleColor,
                  ))),
            )
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            passwordInput(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      body: content(),
      resizeToAvoidBottomInset: false,
    );
  }
}
