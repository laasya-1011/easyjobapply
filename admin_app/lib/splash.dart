import 'dart:async';

import 'package:admin_app/src/providers/fcm_provider.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/auth/login.dart';
import 'package:admin_app/src/views/job_posts/homepage.dart';
import 'package:admin_app/src/views/profile/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // how to call providers in widgets
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final fcmProvider = Provider.of<FcmProvider>(context, listen: false);
    Timer(Duration(seconds: 3), () async {
      if (auth.currentUser == null) {
        // go to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        await fcmProvider.ensureFcmToken();
        profileProvider.profileStatus().then((value) {
          if (value == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            profileProvider
                .checkProfile(uid: auth.currentUser.uid)
                .then((hasProfile) async {
              if (hasProfile == true) {
                // save profile status and move to home page
                profileProvider
                    .saveProfileStatus(hasProfile: true)
                    .then((value) {
                  // navigate to home screen
                  //
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                });
              } else {
                // create profile
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 160,
            ),
            Text(
              'Hey',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Easy Job Portal',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Welcomes You',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 17),
            )
          ],
        ),
      ),
    );
  }
}
