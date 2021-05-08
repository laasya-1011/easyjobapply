import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:flutter/cupertino.dart';

class JobProvider with ChangeNotifier {
  Future createJob({
    @required String admin_uid,
    @required String admin_name,
    @required String jobTitle,
    @required String description,
  }) async {
    try {
      var add_job = <String, dynamic>{
        'uid': DateTime.now().microsecondsSinceEpoch,
        'admin_uid': admin_uid,
        'admin_name': admin_name,
        'jobTitle': jobTitle,
        'description': description,
        'created_date': DateTime.now().toLocal(),
        'userApplied': []
      };
      await db
          .collection('jobs')
          .doc(DateTime.now().microsecondsSinceEpoch.toString())
          .set(add_job)
          .then((value) {});
    } catch (e) {}
  }

  Future createJobResponse(
      {@required String admin_uid,
      @required int job_id,
      @required String response,
      @required bool selected,
      @required String docId,
      @required String user_uid}) async {
    try {
      var addJobResponse = <String, dynamic>{
        'user_uid': user_uid,
        'admin_uid': admin_uid,
        'job_id': job_id,
        'selected': selected,
        'response': response,
        'created_date': DateTime.now().toLocal()
      };
      await db
          .collection('jobs')
          .doc(docId)
          .collection('job_response')
          .doc()
          .set(addJobResponse)
          .then((value) {});
    } catch (e) {}
  }
}
