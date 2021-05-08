import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyjob/src/providers/fcm_provider.dart';
import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/payment/razor_payment.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget jobCard(
    {@required BuildContext context,
    @required String jobTitle,
    @required String description,
    @required String id,
    @required String admin_uid}) {
  apply({@required String docId, @required String uid}) {
    db.collection('jobs').doc(docId).update({
      "userApplied": FieldValue.arrayUnion([uid])
    }).then((value) {
      print("updated");
    });
  }

  final fcmProvider = Provider.of<FcmProvider>(context, listen: false);
  String admin_token = '';
  String userName = '';
  List<String> fcmTokens = [];
  List<String> listUids = [];
  Future<void> pushNotification() async {
    //admin_token = await fcmProvider.getOtherUserFcmToken(uid: admin_uid);
    print('admin uid $admin_uid');

    listUids.add(admin_uid);

    await fcmProvider.getAllMemberFcm(membersUid: listUids).then((listTokens) {
      for (int i = 0; i < listTokens.length; i++) {
        var token = listTokens[i];
        fcmTokens.add(token);
      }
    });
    await db
        .collection('userProfile')
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      userName = value['first_name'];
    });
    await fcmProvider.sendSingleChatNotification(
        rToken: fcmTokens,
        title: jobTitle,
        msgBody: 'user $userName has applied to the  $jobTitle job');
  }

  Future<List<String>> getMembersUid(
      {@required String currentUserUid, @required String docId}) async {
    List<String> _membersUid = [];
    dynamic data;

    final DocumentReference document =
        fireStoreSnapshotRef.collection('jobs').doc(docId);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      data = snapshot.data();
    });
    _membersUid = List<String>.from(data['userApplied']);
    return _membersUid;
  }

  List<String> _membersUid = [];

  final snackbar = SnackBar(
      backgroundColor: Colors.white,
      duration: Duration(seconds: 2),
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JOB Applied Succesfully ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            Icon(
              Icons.verified,
              color: Colors.greenAccent[400],
            )
          ],
        ),
      ));

  return StreamBuilder(
      stream: fireStoreSnapshotRef.collection('jobs').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: Text('no data'),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot == null) {
            return Container(child: Text('Not applied yet to any jobs'));
          } else {
            _membersUid = List<String>.from(snapshot.data['userApplied']);

            return Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.227,
              margin: EdgeInsets.fromLTRB(25, 3, 25, 25),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        width: MediaQuery.of(context).size.width * 0.03,
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _membersUid.contains(auth.currentUser.uid) ==
                                  false
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          jobTitle,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      description,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_membersUid.contains(auth.currentUser.uid)) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Would you like to pay now to apply for this job?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
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
                                    onTap: () {
                                      apply(
                                          docId: id, uid: auth.currentUser.uid);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentPage()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                      pushNotification();
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
                      } else {
                        print("no dialogue");
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: _membersUid.contains(auth.currentUser.uid)
                              ? Colors.red
                              : Colors.green,
                        ),
                        child: Text(
                          _membersUid.contains(auth.currentUser.uid)
                              ? 'Applied'
                              : 'Apply',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )),
                  ),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: Container(
              child: Text('Can\'t show the data'),
            ),
          );
        }
      });
}
