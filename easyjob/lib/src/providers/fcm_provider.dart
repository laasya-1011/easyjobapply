import 'dart:convert';

import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class FcmProvider with ChangeNotifier {
  FcmProvider() {}
  getUid() {}
  Future ensureFcmToken() async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    final snapshot = await fireStoreSnapshotRef
        .collection("userFcmToken")
        .where("uid", isEqualTo: uid)
        .get();
    if (snapshot.docs.length == 0) {
      saveDeviceToken(uid: uid);
    } else {
      updateDeviceToken(uid: uid);
    }
  }

  saveDeviceToken({@required String uid}) async {
    // Get the token for this device
    String fcmToken = await fcm.getToken();
    print(fcmToken);
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = db.collection('userFcmToken').doc(uid);
      //  .collection('tokens')
      //   .document(fcmToken);
      await tokens.set({
        'fcmToken': fcmToken,
        'createdAt': DateTime.now().toString(), // optional
        'platform': Platform.operatingSystem // optional
      });
      // print("token saved");
    }
  }

  updateDeviceToken({@required String uid}) async {
    // Get the token for this device
    String fcmToken = await fcm.getToken();
    print(fcmToken);
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = db
          .collection('userFcmToken')
          //      .document(uid)
          //      .collection('tokens')
          .doc(uid);
      await tokens.update({
        'fcmToken': fcmToken,
        'createdAt': DateTime.now().toString(), // optional
        'platform': Platform.operatingSystem // optional
      });
      print("token updated");
    }
  }

// single fcmtoken  based on uid
  Future<String> getOtherUserFcmToken({@required String uid}) async {
    String token = "";
    await db.collection("userFcmToken").doc(uid).get().then((value) {
      token = value['fcmToken'];
      return value['fcmToken'];
    });
    return token;
  }

  // get multiple fcmtoken at a time based on uid list
  Future<List<String>> getAllMemberFcm(
      {@required List<String> membersUid}) async {
    List<String> _membersFcm = [];
    for (var item in membersUid) {
      await db.collection("userFcmToken").doc(item).get().then((value) {
        var token = value['fcmToken'];
        _membersFcm.add(token);
      });
    }
    return _membersFcm;
  }

  Future<bool> sendSingleChatNotification({
    @required List<String> rToken,
    @required String title,
    @required String msgBody,
  }) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": rToken,
      "collapse_key": "type_a",
      "sound": "default",
      // 'id': '1',
      'status': 'done',
      "data": {
        "screen": "homepage",
      },
      "notification": {
        "title": title,
        "body": msgBody,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAh9wigpc:APA91bGfIU7ZDZOMzD54y3H0PC10UxAJoptdNa7OuDOiMrIRbFeK0AX1MimiGC-LeVKm7Ohw4tXSEJaOUZf1vvAaxgS_-8GEzdg7eQEKZssXPCZg2FQa4gt1Laykh8YhyJGmORV5DcDi'
    };
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
