import 'package:flutter/material.dart';
import 'package:kopi_combi/dto/user.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/theme.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserDTO user =
        Provider.of<AuthProvider>(context).user ?? UserDTO(name: '', email: '');

    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address ?? '';
    _phoneNumberController.text = user.phoneNumber ?? '';

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
          'Edit Profile',
          style: primaryTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .updateProfil(credential: {
                'email': _emailController.text,
                'name': _nameController.text,
                'address': _addressController.text,
                'phone_number': _phoneNumberController.text,
              });
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

    Widget nameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Lengkap',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: primaryTextStyle,
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: user.name,
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

    Widget phoneNumberInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Telepon',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: primaryTextStyle,
              controller: _phoneNumberController,
              decoration: InputDecoration(
                  hintText: user.phoneNumber,
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

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: primaryTextStyle,
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: user.email,
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

    Widget addressInput() {
      return Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat',
              style: secondaryTextStyle.copyWith(
                fontSize: 13,
              ),
            ),
            TextFormField(
              style: primaryTextStyle,
              controller: _addressController,
              decoration: InputDecoration(
                  hintText: user.address,
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
      String? avatarUrl = user.photoUrl ?? 'assets/image_profile.png';
      if (avatarUrl.contains('ui-avatars.com')) {
        avatarUrl = '$avatarUrl&size=100';
      }
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: avatarUrl != 'assets/image_profile.png'
                      ? NetworkImage(avatarUrl)
                      : AssetImage(
                          'assets/image_profile.png',
                        ) as ImageProvider,
                ),
              ),
            ),
            nameInput(),
            phoneNumberInput(),
            emailInput(),
            addressInput()
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
