import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:easyjob/src/widgets/appliedjobcard.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class AppliedJobs extends StatefulWidget {
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  Stream jobSnapshot;
  List appliedJobs = <String>[
    'Android App Developer',
    'Software Developer',
    'Full Stack Developer',
    'UI/UX Designer',
    'Digital Marketing',
  ];
  String description =
      'Design and build advanced applications for the Android platform';

  getUserJobResponse() {
    jobSnapshot = fireStoreSnapshotRef
        .collection('jobs')
        .where('userApplied', arrayContains: auth.currentUser.uid)
        .get()
        .asStream();
    setState(() {});
  }

  @override
  void initState() {
    getUserJobResponse();
    super.initState();
  }

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
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: width,
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Text(
                'Applied Jobs',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
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
              height: height * 0.8,
              child: StreamBuilder(
                  stream: jobSnapshot,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          child: Text('  '),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data.docs.length == 0) {
                        return Container(
                            child: Text('Not yet received job responses'));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return appliedJobCard(
                                  context: context,
                                  //i have set here true by default sir THATS WHY IT is ahowing accepted
                                  jobTitle: snapshot.data.docs[index]
                                      ['jobTitle'],
                                  description: snapshot.data.docs[index]
                                      ['description'],
                                  docId: snapshot.data.docs[index].id,
                                  tapWork: true);
                            });
                      }
                    } else {
                      return Center(
                        child: Container(
                          child: Text('Can\'t show the data'),
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 250,
            )
          ],
        ),
      ),
    );
  }
}
/*ListView.builder(
                  itemCount: appliedJobs.length,
                  itemBuilder: (context, index) {
                    return appliedJobCard(
                    context:  context, 
                    accepted:  index % 2 == 0,
                     jobTitle:   appliedJobs[index],
                       description:  description);
                  }) */