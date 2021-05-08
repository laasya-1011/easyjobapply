import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/widgets/jobcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  bool isLoading = false;

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
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
              ),
            ),
          )
        : Scaffold(
            body: Container(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      'Hey, ${_profile['first_name']} ',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    width: width,
                    margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                      'Jobs Posted By You',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    height: height * 0.0035,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      width: width,
                      height: height * 0.638,
                      child: StreamBuilder(
                          stream: db
                              .collection('jobs')
                              .where("admin_uid",
                                  isEqualTo: auth.currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data.docs.length == 0) {
                                return Center(
                                    child: Text(
                                  'POST JOB APPLICATIONS NOW',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                ));
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return jobCard(
                                        context: context,
                                        jobTitle: snapshot.data.docs[index]
                                            ['jobTitle'],
                                        description: snapshot.data.docs[index]
                                            ['description'],
                                        doc: snapshot.data.docs[index],
                                      ); // always make constructors with required parameters//ok sir//sir 2min I will set this up////
                                    });
                              }
                            } else {
                              return Center(
                                child: Container(
                                  child: Text('Can\'t show the data'),
                                ),
                              );
                            }
                          })),
                ],
              ),
            ),
          );
  }
}
