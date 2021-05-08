import 'package:admin_app/src/providers/fcm_provider.dart';
import 'package:admin_app/src/providers/job_provider.dart';
import 'package:admin_app/src/views/resume_view/resume_view.dart';
//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:admin_app/src/providers/profile_provider.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/applications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ApplicationCard extends StatefulWidget {
  final String userUid;
  final int jobId;
  final String jobTitle;
  final DocumentSnapshot doc;
  final String docId;
  ApplicationCard(
      {this.userUid,
      this.jobId,
      this.jobTitle,
      this.doc,
      @required this.docId});
  @override
  _ApplicationCardState createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<ApplicationCard> {
  TextEditingController textController = TextEditingController();
  // PDFDocument document;
  bool isLoading = false;
  bool isAdminResponded = false;
  bool isSelected;
  String userName;
  String profileUrl;
  String resumeUrl;
  userCheck() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (await profileProvider.checkProfile(uid: widget.userUid) == true) {
      setState(() {
        isLoading = true;
      });
      await fireStoreSnapshotRef
          .collection("userProfile")
          .where('uid', isEqualTo: widget.userUid)
          .limit(1)
          .get()
          .then((queryResult) async {
        // here
        print(queryResult.docs[0]['first_name']);
        userName = await queryResult.docs[0]['first_name'];
        profileUrl = await queryResult.docs[0]['profile_picture'];
        resumeUrl = await queryResult.docs[0]['resume'];

        ///
        setState(() {
          print(userName ?? 'no user found');
        });
      });

      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Can\'t find the user\'s profile');
    }
  }

  responseCheck({@required docId}) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (await profileProvider.checkProfile(uid: widget.userUid) == true) {
      setState(() {
        isLoading = true;
      });
      await fireStoreSnapshotRef
          .collection("userProfile")
          .where('uid', isEqualTo: widget.userUid)
          .limit(1)
          .get()
          .then((queryResult) async {
        // here
        print(queryResult.docs[0]['first_name']);
        userName = await queryResult.docs[0]['first_name'];
        profileUrl = await queryResult.docs[0]['profile_picture'];
        resumeUrl = await queryResult.docs[0]['resume'];

        ///
        setState(() {
          print(userName ?? 'no user found');
        });
      });

      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'Can\'t find the user\'s profile');
    }
  }

  saveNote() async {
    await db.collection('jobs').doc(widget.doc.id).get().then((value) async {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await jobProvider
          .createJobResponse(
              admin_uid: auth.currentUser.uid,
              job_id: widget.jobId,
              response: textController.text,
              selected: isSelected,
              user_uid: widget.userUid,
              docId: widget.doc.id)
          .then((value) {
        print('saved response');
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Applications(
                    doc: widget.doc,
                  )),
        );
      });
    });
  }

  String user_token = '';

  List<String> fcmTokens = [];
  List<String> listUids = [];
  //Future<void>
  pushNotification() async {
    final fcmProvider = Provider.of<FcmProvider>(context, listen: false);
    //user_token = await fcmProvider.getOtherUserFcmToken(
    //   uid: userUid); 
    print("listuserid: ${widget.userUid}");
    listUids.add(widget.userUid);

    await fcmProvider.getAllMemberFcm(membersUid: listUids).then((listTokens) {
    
      for (int i = 0; i < listTokens.length; i++) {
        var token = listTokens[i];
        print("listTokenid: $token");
        fcmTokens.add(token);
      }
    }).catchError((e) {});

    await fcmProvider
        .sendSingleChatNotification(
            rToken: fcmTokens,
            title: widget.jobTitle,
            msgBody:
                'Admin has replied to your  ${widget.jobTitle} job application')
        .then((value) {
      if (value == true)
        print('success');
      else
        print('fail');
    }).catchError((e) {
      print(e);
    });
  }

 
  noteBox() {
    return showDialog(
        context: context,
        builder: (context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Container(
                      height: height * 0.3,
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[400], blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText:
                              'Please provide the response with a proper note',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ),
                    ),
                    Positioned(
                        top: height * 0.32,
                        left: width * 0.4,
                        child: GestureDetector(
                          onTap: () {
                            pushNotification();
                            saveNote();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent,
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  resumeView() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResumeViewer(
                url: resumeUrl,
              )),
    );
  }

  selectResponse() async {
    await fireStoreSnapshotRef
        .collection('jobs')
        .doc(widget.docId)
        .collection('job_response')
        .where('user_uid', isEqualTo: widget.userUid)
        .limit(1)
        .get()
        .then((query) async {
      var usr = await query.docs[0]['user_uid'];
      if (usr == widget.userUid) {
        isAdminResponded = true;
        setState(() {});
      } else if (query.docs.length == 0) {
        isAdminResponded = false;
        setState(() {});
      } else {
        isAdminResponded = false;
        setState(() {});
      }
    }).catchError((e) {
      isAdminResponded = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    userCheck();
    selectResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading ||
            profileUrl == null ||
            userName == null ||
            resumeUrl == null ||
            isAdminResponded == null
        ? Center(
            child: Text('  '),
          )
        : Container(
            width: width,
            child: Center(
              child: Container(
                alignment: Alignment.topCenter,
                width: width,
                // height: height * 0.2,
                margin: EdgeInsets.fromLTRB(25, 3, 25, 25),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[400], blurRadius: 2)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(8),
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(profileUrl) ??
                                        AssetImage(
                                            'assets/images/profile.png')),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 5),
                              child: Text(
                                userName ?? 'No user applied yet', //sir done
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: resumeView,
                          child: Container(
                            width: width * 0.25,
                            height: height * 0.06,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(width * 0.22, 5, 5, 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red,
                            ),
                            child: Text(
                              'resume',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    isAdminResponded
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Already Responded!',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                child: TextButton(
                                    onPressed: () {
                                      isSelected = true;

                                      setState(() {});
                                      noteBox();
                                    },
                                    child: Text(
                                      'Select',
                                      style: TextStyle(color: Colors.green),
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: TextButton(
                                    onPressed: () {
                                      isSelected = false;
                                      setState(() {});
                                      noteBox();
                                    },
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          );
  }
}

/* Container(
          height: height * 0.25,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 2)],
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: textController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Please provide the response with a proper note',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),
        ),*/
