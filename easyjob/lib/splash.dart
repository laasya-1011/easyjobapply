import 'dart:async';

import 'package:easyjob/src/providers/fcm_provider.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/auth/login.dart';

import 'package:easyjob/src/views/job/joblist.dart';
import 'package:easyjob/src/views/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
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
              MaterialPageRoute(builder: (context) => JobList()),
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
                    MaterialPageRoute(builder: (context) => JobList()),
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
    // this is build // from here to end of this function//got it sir
    final profileProvider = Provider.of<ProfileProvider>(context);
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
