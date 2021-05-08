import 'dart:io';
import 'package:admin_app/src/providers/storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/homepage.dart';
import 'package:admin_app/src/widgets/textfieldInputDeco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final UserCredential user;

  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File _image;

  Future<String> url;
  bool isLoading = false;
  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Both,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ),
    );
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      emailController.text = widget.user.user.email;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: width,
                height: height,
                child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Text(
                        'Easy Job Portal',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            width: width,
                            // height: 240,
                            margin: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[400], blurRadius: 2)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Create Profile',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: Colors.black45, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: Container(
                                        width: height * 0.15,
                                        height: height * 0.15,
                                        /*  */
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: _image == null
                                                    ? AssetImage(
                                                        'assets/images/profile.png',
                                                      )
                                                    : FileImage(
                                                        _image,
                                                      )),
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 20,
                                      bottom: 5,
                                      child: Container(
                                        width: height * 0.05,
                                        height: height * 0.05,
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: IconButton(
                                            splashColor: Colors.red[50],
                                            alignment: Alignment.center,
                                            icon: Icon(
                                              Icons.add_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: getImage),
                                      ),
                                    )
                                  ],
                                ),
                                Form(
                                  key: formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.105),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: height * 0.105,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 5),
                                        child: TextFormField(
                                          validator: (val) {
                                            return RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(val)
                                                ? null
                                                : 'Please provide a valid emailID';
                                          },
                                          controller: emailController,
                                          style: TextStyle(
                                              color: Colors.black,
                                              decoration: TextDecoration.none),
                                          decoration: textFieldInputDeco(
                                              'abc@gmail.com'),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.105),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: height * 0.105,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 5),
                                        child: TextFormField(
                                          validator: (val) {
                                            return val.length != 0
                                                ? null
                                                : 'please provide valid first name ';
                                          },
                                          controller: firstNameController,
                                          style: TextStyle(
                                              color: Colors.black,
                                              decoration: TextDecoration.none),
                                          decoration:
                                              textFieldInputDeco('First Name'),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.105),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: height * 0.105,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 5),
                                        child: TextFormField(
                                          validator: (val) {
                                            return val.length != 0
                                                ? null
                                                : 'please provide valid last name ';
                                          },
                                          controller: lastNameController,
                                          style: TextStyle(
                                              color: Colors.black,
                                              decoration: TextDecoration.none),
                                          decoration:
                                              textFieldInputDeco('Last Name'),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.105),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: height * 0.105,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 5),
                                        child: TextFormField(
                                          validator: (val) {
                                            return val.length == 10
                                                ? null
                                                : 'invalid mobile number ';
                                          },
                                          keyboardType: TextInputType.phone,
                                          controller: phController,
                                          obscureText: true,
                                          style: TextStyle(color: Colors.black),
                                          decoration: textFieldInputDeco(
                                              'Phone Number'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: height * 0.003,
                              //bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    addFileToFirebase(
                                            filePath: _image
                                                .path, // give profile pic pa
                                            firebasePath: "profilePicture")
                                        .then((profilePickUrl) async {
                                      await profileProvider
                                          .createProfile(
                                        uid: auth.currentUser.uid,
                                        email: emailController.text,
                                        firstName: firstNameController
                                            .text, // fill these
                                        lastName: lastNameController.text,
                                        phoneNumber:
                                            int.parse(phController.text),
                                        profilepicUrl: profilePickUrl,
                                      )
                                          .then((val) async {
                                        await profileProvider
                                            .checkProfile(
                                                uid: auth.currentUser.uid)
                                            .then((hasProfile) {
                                          print(
                                              "uid 2 ${auth.currentUser.uid}");
                                          if (hasProfile == true) {
                                            profileProvider
                                                .saveProfileStatus(
                                                    // saving status
                                                    hasProfile: true)
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()),
                                              );
                                            });
                                            print("uid 3 has profile");
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            print(
                                                "something went wrong.. try again");
                                          }
                                        }).catchError((err) {
                                          setState(() {
                                            isLoading = false;
                                          });

                                          Fluttertoast.showToast(
                                            msg: "${err.message}",
                                          );
                                        });
                                      });
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  margin: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ]),
              ),
            ),
    );
  }
}
