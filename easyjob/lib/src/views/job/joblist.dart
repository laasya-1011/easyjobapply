import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyjob/src/providers/auth_provider.dart';
import 'package:easyjob/src/providers/profile_provider.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/auth/login.dart';
import 'package:easyjob/src/views/job/appliedjobs.dart';
import 'package:easyjob/src/views/profile/updateprofile.dart';
import 'package:easyjob/src/widgets/job_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:get/get.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  bool isLoading = false;

  List jobs = <String>[
    'Android App Developer',
    'Data Scientist',
    'Embedded Developer',
    'Software Developer',
    'Web Developer',
    'ML Engineer',
    'Full Stack Developer',
    'CyberSecurity',
    'UI/UX Designer',
    'Digital Marketing',
    'Product Manager'
  ];
  String description =
      'Design and build advanced applications for the Android platform';

  Widget drawer() {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
        width: MediaQuery.of(context).size.width * 0.77,
        color: Colors.white,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black45, width: 1),
                  borderRadius: BorderRadius.circular(60)),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.15,
                height: MediaQuery.of(context).size.height * 0.15,
                /*  */
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          _profile['profile_picture'],
                        )),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(60)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              //  margin: EdgeInsets.all(8),
              child: Text(
                _profile['first_name'],
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppliedJobs()),
                );
              },
              horizontalTitleGap: 1,
              leading: Icon(Icons.home_repair_service),
              title: Text(
                'Applied Job',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfile()),
                );
              },
              horizontalTitleGap: 1,
              leading: Icon(Icons.perm_identity),
              title: Text(
                'Profile',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            ListTile(
              onTap: () async {
                await authProvider.logout().then((value) async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                });
              },
              horizontalTitleGap: 1,
              leading: Icon(Icons.logout),
              title: Text(
                'LogOut',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1.2,
            )
          ],
        ));
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

  apply() async {}
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
            drawerEdgeDragWidth: width * 0.7,
            drawerScrimColor: Colors.black38,
            drawer: drawer(),
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
            ),
            body: Container(
              width: width,
              height: height,
              alignment: Alignment.centerLeft,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      'Hey, ${_profile['first_name']}',
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
                      'Top Picks For You',
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
                      height: height,
                      child: StreamBuilder(
                          stream: db.collection('jobs').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data.docs.length == 0) {
                                return Container(child: Text('   '));
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      // print(snapshot.data.docs[index].id);

                                      return jobCard(
                                        context: this.context,
                                        jobTitle: snapshot.data.docs[index]
                                            ['jobTitle'],
                                        description: snapshot.data.docs[index]
                                            ['description'],
                                        id: snapshot.data.docs[index].id,
                                        admin_uid: snapshot.data.docs[index]
                                            ['admin_uid'],
                                      );
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
/* db
 .collection('jobs') 
 .where('jobTitle', isEqualTo: snapshot.data .docs[index]['jobTitle']) 
 .where('userApplied', arrayContains: auth.currentUser.uid)
 .limit(1) */