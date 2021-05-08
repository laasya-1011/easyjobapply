import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/job_wise_response.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobResponse extends StatefulWidget {
  @override
  _JobResponseState createState() => _JobResponseState();
}

class _JobResponseState extends State<JobResponse> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
          stream: fireStoreSnapshotRef
              .collection('jobs')
              .where("admin_uid", isEqualTo: auth.currentUser.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: width,
                height: height * 0.8,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return Container(
                width: width,
                height: height * 0.8,
                child: ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      width: width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      child: Text(
                        'Applications, you have responded',
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
                    ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobWiseResponse(
                                          docId: snapshot.data.docs[index].id,
                                          jobTitle: snapshot.data.docs[index]
                                              ['jobTitle'],
                                        )),
                              );
                            },
                            child: Container(
                              width: width,
                              height: height * 0.105,
                              margin: EdgeInsets.fromLTRB(25, 3, 25, 25),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red[400], blurRadius: 3)
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data.docs[index]['jobTitle'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data.docs[index]['description'],
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            } else {
              return Container(
                child: Text('data'),
              );
            }
          }),
    );
  }
}
/**ListView(
                          
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                           
                           ,
                          ],
                        ), */