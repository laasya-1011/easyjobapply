import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:admin_app/src/views/job_posts/response_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ResponseCard({
  String response,
  bool tapWork,
  @required String userId,
  @required String jobTitle,
  @required bool selected,
  @required BuildContext context,
}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return GestureDetector(
    onTap: () {
      tapWork
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResponsePage(
                        jobTitle: jobTitle,
                        selected: selected,
                        response: response,
                        userId: userId,
                      )))
          : null;
    },
    child: Container(
      width: width,
      height: height * 0.175,
      margin: EdgeInsets.fromLTRB(25, 3, 25, 25),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.width * 0.03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: selected ? Colors.green : Colors.red,
                ),
              ),
              StreamBuilder(
                  stream: fireStoreSnapshotRef
                      .collection('userProfile')
                      .where('uid', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return Center(
                        child: Container(
                          child: Text('  '),
                        ),
                      );
                    } else if (snap.hasData) {
                      if (snap.data == null) {
                        return Container(child: Text(' ')); //
                      } else {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            snap.data.docs[0]['first_name'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
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
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: selected ? Colors.green : Colors.red,
            ),
            child: Text(
              selected ? 'Selected' : 'Rejected',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10),
            ),
          ),
        ],
      ),
    ),
  );
}
/* return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  snap.data['first_name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              );*/
