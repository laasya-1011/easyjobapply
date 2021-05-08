import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/widgets/response_card.dart';
import 'package:flutter/material.dart';

class JobWiseResponse extends StatefulWidget {
  final String docId;
  final String jobTitle;
  JobWiseResponse({@required this.docId, @required this.jobTitle});
  @override
  _JobWiseResponseState createState() => _JobWiseResponseState();
}

class _JobWiseResponseState extends State<JobWiseResponse> {
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
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(
                child: Container(
                  child: Text('no data'),
                ),
              );
            } else if (snap.hasData) {
              if (snap.data.docs.length == 0) {
                return Center(child: Text('No responses '));
              } else {
                return Container(
                  width: width,
                  height: height,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.jobTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
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
                        width: width * 0.8,
                        height: height,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: snap.data.docs.length,
                            itemBuilder: (context, ind) {
                              return ResponseCard(
                                  tapWork: true,
                                  jobTitle: widget.jobTitle,
                                  context: context,
                                  userId: snap.data.docs[ind]['user_uid'],
                                  selected: snap.data.docs[ind]['selected'],
                                  response: snap.data.docs[ind]['response']);
                            }),
                      ),
                      SizedBox(
                        height: height * 0.08,
                      )
                    ],
                  ),
                );

                //)

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
