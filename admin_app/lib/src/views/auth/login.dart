import 'package:admin_app/src/providers/auth_provider.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/auth/forgot_password.dart';
import 'package:admin_app/src/views/job_posts/homepage.dart';
import 'package:admin_app/src/views/profile/create_profile.dart';

import 'package:admin_app/src/widgets/textfieldInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      'Easy Job Portal',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: width,
                          height: height * 0.35,
                          margin: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 30),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey[400], blurRadius: 2)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login ',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      height: height * 0.055,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 20),
                                      child: TextFormField(
                                        validator: (val) {
                                          return RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(val)
                                              ? null
                                              : 'Please provide a valid emailID';
                                        },
                                        controller: emailID,
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.none),
                                        decoration: textFieldInputDeco(
                                            'Enter your Email ID'),
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      height: height * 0.055,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 8),
                                      child: TextFormField(
                                        validator: (val) {
                                          return val.length > 7
                                              ? null
                                              : 'minimum 8 characters needed ';
                                        },
                                        controller: password,
                                        obscureText: true,
                                        style: TextStyle(color: Colors.black),
                                        decoration: textFieldInputDeco(
                                            'Enter Password'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: height * 0.365,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });
                                authProvider
                                    .emailSignIn(
                                        email: emailID.text,
                                        pass: password.text)
                                    .then((user) {
                                  if (user != null) {
                                    profileProvider
                                        .checkProfile(uid: auth.currentUser.uid)
                                        .then((hasProfile) {
                                      if (hasProfile == true) {
                                        profileProvider
                                            .saveProfileStatus(hasProfile: true)
                                            .then((value) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        });
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Profile(
                                                      user: user,
                                                    )));
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print("something went wrong");
                                  }
                                }).catchError((err) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Fluttertoast.showToast(
                                    msg: "${err.message}",
                                  );
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 13),
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
