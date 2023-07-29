import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/theme.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    void signOut() async {
      bool? destroySession =
          await Provider.of<AuthProvider>(context, listen: false).signOut();
      if (destroySession! && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/sign-in', (route) => false);
      }
    }

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Consumer<AuthProvider>(builder: (context, auth, child) {
            String? avatarUrl =
                auth.user?.photoUrl ?? 'assets/image_profile.png';
            if (avatarUrl.contains('ui-avatars.com')) {
              avatarUrl = '$avatarUrl&size=100';
            }
            return Container(
              padding: EdgeInsets.all(
                defaultMargin,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: avatarUrl != 'assets/image_profile.png'
                        ? Image.network(
                            avatarUrl,
                            width: 64,
                          )
                        : Image.asset(
                            'assets/image_profile.png',
                            width: 64,
                          ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.name ?? '',
                          style: primaryTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: semibold,
                          ),
                        ),
                        Text(
                          auth.user?.email ?? '',
                          style: subtitleTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => signOut(),
                    child: Image.asset(
                      'assets/button_exit.png',
                      width: 20,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      );
    }

    Widget menuItem(String text) {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: secondaryTextStyle.copyWith(fontSize: 13),
            ),
            Icon(
              Icons.chevron_right,
              color: primaryTextColor,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          decoration: BoxDecoration(
            color: backgroundColor3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Account',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semibold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: menuItem(
                  'Edit Profile',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-password');
                },
                child: menuItem(
                  'Change Password',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/transaction');
                },
                child: menuItem(
                  'Your Orders',
                ),
              ),
              // menuItem(
              //   'Help',
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              // Text(
              //   'Account',
              //   style: primaryTextStyle.copyWith(
              //     fontSize: 16,
              //     fontWeight: semibold,
              //   ),
              // ),
              // menuItem(
              //   'Privacy & Policy',
              // ),
              // menuItem(
              //   'Term of Service',
              // ),
              // menuItem(
              //   'Rate App',
              // ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}
