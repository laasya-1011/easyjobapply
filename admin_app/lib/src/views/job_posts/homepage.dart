import 'package:admin_app/src/providers/auth_provider.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/auth/login.dart';
import 'package:admin_app/src/views/job_posts/addpost.dart';
import 'package:admin_app/src/views/job_posts/job_response.dart';
import 'package:admin_app/src/views/job_posts/joblist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isLoading = false;
  final screenSel = [JobList(), JobResponse()];
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
    final authProvider = Provider.of<AuthProvider>(context);
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    //
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
              backgroundColor: Colors.redAccent,
              leading: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                width: width * 0.1,
                height: width * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        _profile['profile_picture'],
                      )),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPost()),
                    );
                  },
                  icon: Icon(
                    Icons.post_add_sharp,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Are you sure you want to signout ?',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'NO',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await authProvider
                                      .logout()
                                      .then((value) async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  });
                                },
                                child: Text(
                                  'YES',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                            actionsPadding: EdgeInsets.all(8),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: screenSel[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                elevation: 12,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: Colors.redAccent,
                mouseCursor: MouseCursor.defer,
                showUnselectedLabels: true,
                selectedItemColor: Colors.redAccent[100],
                selectedLabelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                selectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      backgroundColor: Colors.redAccent[100],
                      label: 'Jobs',
                      icon: Icon(
                        Icons.assessment_outlined,
                        color: Colors.white,
                      )),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.redAccent[100],
                      label: 'Response',
                      icon: Icon(
                        Icons.assignment_rounded,
                        color: Colors.white,
                      ))
                ]),
          );
  }
}
