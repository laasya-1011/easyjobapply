import 'package:easyjob/src/providers/auth_provider.dart';
import 'package:easyjob/src/widgets/textInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _namecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Forgot Password',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                width: width,
                height: height * 0.3,
                margin: EdgeInsets.fromLTRB(50, 50, 50, 20),
                child: Image.asset(
                  'assets/images/lock.png',
                  fit: BoxFit.fitHeight,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: width,
                height: height * 0.08,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: _namecontroller,
                  decoration: textFieldInputDeco('Enter your Email ID'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  authProvider.resetPass(_namecontroller.text);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  margin: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0,
                            color: Colors.red,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(7)),
                  width: width * 0.6,
                  child: Text(
                    'Verify My Account',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13, letterSpacing: 1.9),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(40),
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Please check your email, we will send one OTP code on your device.',
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ));
  }
}
