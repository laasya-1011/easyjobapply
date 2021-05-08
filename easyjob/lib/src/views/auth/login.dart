// inside models all models will go
// insde view all ui
// inside provider all provider
// inside constants all constants
// inside utils all utilities related to some provider
// inside widgets all individual widgets will go .. say job card

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyjob/src/providers/auth_provider.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/auth/forgot_password.dart';

import 'package:easyjob/src/views/auth/signup.dart';
import 'package:easyjob/src/views/job/joblist.dart';
import 'package:easyjob/src/views/profile/profile.dart';
import 'package:easyjob/src/widgets/textInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//import 'package:get/get.dart';

class Login extends StatefulWidget {
  final Function toggle;
  Login({this.toggle});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // call provider here then implement login ok sir
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(
        context); //its working sir// just one part left fetching the profile in the screen create the profile first//sir done with creating profile//
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                ),
              )
            : Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Easy Job Portal',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          width: width,
                          height: height * 0.37,
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
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              Text(
                                'Login Here',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
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
                                        }, // craete aprofile
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
                            top: height * 0.385,
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
                                                      JobList()));
                                        });
                                        setState(() {
                                          isLoading = false; // test it
                                        });
                                      } else {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profile()));
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print("something went wrong"); // wait
                                  }
                                }).catchError((err) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // password wrong or account doest exist

                                  Fluttertoast.showToast(
                                    msg: "${err.message}",
                                  );

                                  print(
                                      'Error:: $err'); // this will give exact error // just print it via toast
                                }); // with every future try to use then // then wait for method to complete
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
                                      fontSize: 13),
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
                                color: Colors.redAccent, fontSize: 12),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: height * 0.005,
                      color: Colors.grey[300],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Don\'t Have An Account?',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54), // sign up
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //  Get.to(SignUp());
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
