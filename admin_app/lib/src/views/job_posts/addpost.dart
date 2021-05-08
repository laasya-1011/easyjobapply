import 'package:admin_app/src/providers/job_provider.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DocumentSnapshot _profile;

  savePost() {
    if (formKey.currentState.validate()) {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      jobProvider
          .createJob(
              admin_uid: auth.currentUser.uid,
              admin_name: _profile['first_name'],
              jobTitle: titleController.text,
              description: descController.text)
          .then((value) {});
      setState(() {
        isLoading = false;
      });
    }
  }

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
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                actions: [
                  TextButton(
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        savePost();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }),
                ]),
            body: Container(
              width: width,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[400], blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: titleController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Job Title',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey[400], blurRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          controller: descController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Job Description',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
