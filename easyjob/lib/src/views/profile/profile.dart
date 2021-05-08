import 'dart:io';

import 'package:easyjob/main.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/providers/storage.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';

import 'package:easyjob/src/views/job/joblist.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:easyjob/src/widgets/textInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//sir, yes//sir, did you get me//user needs profile but  he needs login email and password to login later // yes
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
  bool isResumeUploaded = false;
  File _image;
  File file;

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

  String resumePath = "";
  Future<String> getResume() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
    } else {
      // User canceled the picker
      isResumeUploaded = false;
      setState(() {});
    }
    resumePath = file.path;
    setState(() {});
    return resumePath;
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
                alignment: Alignment.center,
                child: ListView(

                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Easy Job Portal',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        textAlign: TextAlign.center,
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
                                horizontal: 10, vertical: 15),
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
                                        // padding: EdgeInsets.symmetric(horizontal: 10),
                                        height: height * 0.105,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
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
                                Container(
                                  width: height * 0.15,
                                  height: height * 0.17,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[400],
                                          blurRadius: 2)
                                    ],
                                  ),
                                  child: Text(
                                    (isResumeUploaded)
                                        ? '$file.name'
                                        : 'Resume\.pdf ',
                                    style: TextStyle(
                                        color: Colors.grey[350], fontSize: 12),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    /* uploadResume(); */
                                    getResume().then((resumePath) async {
                                      await addFileToFirebase(
                                              filePath: _image.path,
                                              firebasePath: resumePath,
                                              fileType: 'pdf')
                                          .then((pdfUrl) {
                                        isResumeUploaded = true;
                                        setState(() {});
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 25),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: isResumeUploaded
                                          ? Colors.green
                                          : Colors.blue[700],
                                    ),
                                    child: Text(
                                      isResumeUploaded
                                          ? 'Uploaded'
                                          : 'Upload Resume',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: height * 0.004,
                              //bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (formKey.currentState.validate()) {
                                    addFileToFirebase(
                                            filePath: _image
                                                .path, // give profile pic pa
                                            firebasePath: "profilePicture")
                                        .then((profilePickUrl) async {
                                      await addFileToFirebase(
                                              filePath: resumePath,
                                              firebasePath: "resumes")
                                          .then((resumeUrl) async {
                                        await profileProvider
                                            .createProfile(
                                                uid: auth.currentUser.uid,
                                                email: emailController.text,
                                                firstName: firstNameController
                                                    .text, // fill these
                                                lastName:
                                                    lastNameController.text,
                                                phoneNumber: int.parse(
                                                    phController.text),
                                                profilepicUrl: profilePickUrl,
                                                resumeUrl: resumeUrl)
                                            .then((val) async {
                                          await profileProvider
                                              .checkProfile(
                                                  uid: auth.currentUser.uid)
                                              .then((hasProfile) {
                                            print(
                                                "uid 2 ${auth.currentUser.uid}");
                                            if (hasProfile == true) {
                                              //
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
                                                          JobList()),
                                                );
                                              });
                                              print("uid 3 has profile"); //
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              print(
                                                  "something went wrong.. try again");
                                            }
                                          });
                                        });
                                      });
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
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
