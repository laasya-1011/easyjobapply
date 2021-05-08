import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/widgets/appliedjobcard.dart';
import 'package:flutter/material.dart';

///import 'package:get/get.dart';

class AdminFeedback extends StatefulWidget {
  final String jobTitle;
  final String description;
  final String docId;
  final bool accepted;
  AdminFeedback({this.accepted, this.description, this.jobTitle, this.docId});
  @override
  _AdminFeedbackState createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
      body: StreamBuilder(
          stream: fireStoreSnapshotRef
              .collection('jobs')
              .doc(widget.docId)
              .collection('job_response')
              .where("user_uid", isEqualTo: auth.currentUser.uid)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            // print(widget.accepted);
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
                      '  ',
                      textAlign: TextAlign.center,
                    ));
              } else {
                return Container(
                  width: width,
                  height: height,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      appliedJobCard(
                          context: context,
                          jobTitle: widget.jobTitle,
                          description: widget.description,
                          docId: widget.docId,
                          tapWork: false),
                      Container(
                        alignment: Alignment.topCenter,
                        width: width,
                        margin: EdgeInsets.fromLTRB(35, 35, 35, 4),
                        child: Text(
                          'Admin Feedback',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: width,
                        margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
                        child: Text(snapshot.data.docs[0]['response'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                            textAlign: TextAlign.justify),
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
          }),
    );
  }
}
/*widget.accepted ? 'In reference to your application we would like to congratulate you on being selected for the job\. As such\, your job will include training orientation and focus primarily on learning and developing new skills and gaining a deeper understanding of concepts through hands-on application of the knowledge you learned in class.'
                            : 'We regret to inform you that you are not  shortlisted for the job. Company has selected the top 10 members based on the performance. Unfortunately, your performance was not able to come in the top 10 list\.',
                         */
                       