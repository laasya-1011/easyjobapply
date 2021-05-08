import 'package:easyjob/src/providers/auth_provider.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/views/profile/profile.dart';
import 'package:easyjob/src/widgets/textInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//import 'package:get/get.dart';

// this will have only email password and confirm password // yes sir h/e/r  but without these user cannot login right thats why// we navigate him from here //
class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp({this.toggle});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailID =
      TextEditingController(); // both screens ready//
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context); // here no listen
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              // Get.back();
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Easy Job Portal',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              SizedBox(
                height: 80,
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: width,
                    height: height * 0.35,
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                          'SignUp ',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500, //signup new email
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
                                  decoration:
                                      textFieldInputDeco('Enter your Email ID'),
                                ),
                              ),
                              Container(
                                // padding: EdgeInsets.symmetric(horizontal: 10),
                                height: height * 0.05,
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
                                  decoration:
                                      textFieldInputDeco('Enter Password'),
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
                          /*  Get.to(Profile(
                            password: password.text,
                          )); */

                          authProvider
                              .emailSignup(
                                  email: emailID.text, password: password.text)
                              .then((user) {
                            // navigate to profile
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                        user: user,
                                      )),
                            );
                          }).catchError((err) {
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
                            'SignUp',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
