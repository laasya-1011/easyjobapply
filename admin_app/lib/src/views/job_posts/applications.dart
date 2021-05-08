//import 'package:admin_app/src/views/job_posts/joblist.dart';
import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/homepage.dart';
import 'package:admin_app/src/widgets/user_apply_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Applications extends StatefulWidget {
  final DocumentSnapshot doc;
  Applications({this.doc});
  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }),
      ),
      body: Center(
        child: Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topCenter,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: Text(
                  'JobTitle:  ${widget.doc['jobTitle']}',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
              Container(
                color: Colors.grey[300],
                height: height * 0.0035,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              ),
              Container(
                  width: width,
                  height: height * 0.76,
                  child: StreamBuilder(
                      stream: db.collection('jobs').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(
                              child: Text('  '),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data.docs.length == 0) {
                            return Container(child: Text('no Data'));
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    widget.doc['userApplied'].length ?? 0,
                                itemBuilder: (context, index) {
                                  return ApplicationCard(
                                    userUid: widget.doc['userApplied'][index],
                                    jobId: widget.doc['uid'],
                                    jobTitle: widget.doc['jobTitle'],
                                    doc: widget.doc,
                                    docId: widget.doc.id,
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
      ),
    );
  }
}
