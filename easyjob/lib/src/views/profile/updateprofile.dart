import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/providers/storage.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/job/joblist.dart';
import 'package:file_picker/file_picker.dart';

//import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:easyjob/src/widgets/textInputDeco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:file_picker/file_picker.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phController = TextEditingController();
  bool isLoading = false;
  File _image;
  File file;
  final formKey = GlobalKey<FormState>();
  bool isResumeUpdated = false;
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
      _image = image;
    });
  }

  String resumePath = "";
  Future<String> getResume() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
    resumePath = file.path;
    setState(() {});
    return resumePath;
  }

  DocumentSnapshot _profile;

  Future initData() async {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (profileProvider.getProfileData() == null) {
      await profileProvider.getProfile(uid: auth.currentUser.uid).then((value) {
        _profile = profileProvider.getProfileData();
        print(_profile['uid']);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      _profile = profileProvider.getProfileData();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: Container(
            alignment: Alignment.topCenter,
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  ' Profile',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black45, width: 1),
                          borderRadius: BorderRadius.circular(60)),
                      child: Container(
                        width: height * 0.15,
                        height: height * 0.15,
                        /*  */
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image == null
                                    ? NetworkImage(
                                        _profile['profile_picture'],
                                      )
                                    : FileImage(
                                        _image,
                                      )),
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(60)),
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
                            borderRadius: BorderRadius.circular(30)),
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
                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        height: height * 0.06,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return null;
                            }

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
                            _profile['email'],
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        height: height * 0.06,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: TextFormField(
                          controller: firstNameController,
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none),
                          decoration:
                              textFieldInputDeco(_profile['first_name']),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        height: height * 0.06,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: TextFormField(
                          controller: lastNameController,
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none),
                          decoration: textFieldInputDeco(
                            _profile['last_name'],
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        height: height * 0.06,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: TextFormField(
                          validator: (val) {
                            return val.length == 10 || val.isEmpty
                                ? null
                                : 'invalid mobile number ';
                          },
                          keyboardType: TextInputType.phone,
                          controller: phController,
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: textFieldInputDeco(
                              _profile['phone_number'].toString()),
                        ),
                      ),
                      Container(
                        width: height * 0.15,
                        height: height * 0.17,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[400], blurRadius: 2)
                          ],
                        ),
                        child: Text(
                          (isResumeUpdated)
                              ? '$file.name'
                              : '${_profile['first_name']}cv\.pdf ',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
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
                              isResumeUpdated = true;
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
                            color: isResumeUpdated
                                ? Colors.green
                                : Colors.blue[700],
                          ),
                          child: Text(
                            isResumeUpdated ? 'Updated' : 'Update Resume',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    addFileToFirebase(
                            filePath: _image.path,
                            firebasePath: "profilePicture")
                        .then((profilePickUrl) async {
                      await addFileToFirebase(
                              filePath: resumePath, firebasePath: "resumes")
                          .then((resumeUrl) async {
                        await profileProvider
                            .updateProfile(
                                uid: auth.currentUser.uid,
                                email: emailController.text,
                                firstName:
                                    firstNameController.text, // fill these
                                lastName: lastNameController.text,
                                phoneNumber: int.parse(phController.text),
                                profilepicUrl: profilePickUrl,
                                resumeUrl: resumeUrl,
                                docId: auth.currentUser.uid)
                            .then((val) async {
                          await profileProvider
                              .checkProfile(uid: auth.currentUser.uid)
                              .then((hasProfile) {
                            print("uid 2 ${auth.currentUser.uid}"); // wait
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
                                      builder: (context) => JobList()),
                                );
                              });
                              print("uid 3 has profile"); //
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              print("something went wrong.. try again");
                            }
                          });
                        });
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent,
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
