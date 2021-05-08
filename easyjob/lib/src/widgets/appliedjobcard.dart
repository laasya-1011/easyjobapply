import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/views/job/admin_feedback.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';

Widget appliedJobCard(
    {BuildContext context,
    String jobTitle, // send the applied list here
    String description,
    String docId,
    bool tapWork}) {
  return StreamBuilder(
      stream: fireStoreSnapshotRef
          .collection('jobs')
          .doc(docId)
          .collection('job_response')
          .where("user_uid", isEqualTo: auth.currentUser.uid)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: Text(
                '  ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.docs.length == 0) {
            return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' ',
                  textAlign: TextAlign.center,
                ));
          } else {
            return Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.225,
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
                          color: snapshot.data.docs[0]['selected']
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
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      description + '...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      tapWork
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminFeedback(
                                        jobTitle: jobTitle,
                                        description: description,
                                        docId: docId,
                                      )),
                            )
                          : null;
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: snapshot.data.docs[0]['selected']
                              ? Colors.white
                              : Colors.red,
                        ),
                        child: Text(
                          snapshot.data.docs[0]['selected']
                              ? 'Accepted'
                              : 'Rejected',
                          // run this wil//ok sir
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: snapshot.data.docs[0]['selected']
                                  ? Colors.green
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
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
