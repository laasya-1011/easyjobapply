import 'package:admin_app/src/utils/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  Future createProfile({
    @required String uid,
    @required String email,
    @required String firstName,
    @required String lastName,
    @required int phoneNumber,
    @required String profilepicUrl,
  }) async {
    try {
      var profile = <String, dynamic>{
        'uid': uid,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilepicUrl,
        'created_date': DateTime.now().toLocal(),
      };

      await db.collection('admin').doc(uid).set(profile).then((value) {});
    } catch (err) {}
  }

  Future updateProfile({
    @required String docId,
    @required String uid,
    @required String email,
    @required String firstName,
    @required String lastName,
    @required int phoneNumber,
    @required String profilepicUrl,
  }) async {
    try {
      var profile = <String, dynamic>{
        'uid': uid,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilepicUrl,
        'created_date': DateTime.now().toLocal(),
      };

      await db.collection('admin').doc(docId).update(profile).then((value) {});
    } catch (e) {}
  }

  Future<bool> checkProfile({@required String uid}) async {
    final snapshot = await fireStoreSnapshotRef
        .collection("admin")
        .where('uid', isEqualTo: auth.currentUser.uid)
        .get();

    if (snapshot.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  DocumentSnapshot _profile;
  DocumentSnapshot getProfileData() => _profile;
  Future setProfileEmpty() async {
    _profile = null;
    notifyListeners();
  }

  Future<void> getProfile({@required String uid}) async {
    final snapshot = await fireStoreSnapshotRef
        .collection("admin")
        .where('uid', isEqualTo: auth.currentUser.uid)
        .limit(1)
        .get();

    _profile = snapshot.docs[0];
    notifyListeners();
  }

  Future saveProfileStatus({@required bool hasProfile}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile', hasProfile);
  }

  Future<bool> profileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('profile') != null) {
      prefs.getBool('profile');

      return prefs.getBool('profile');
    } else {
      return false;
    }
  }
}
