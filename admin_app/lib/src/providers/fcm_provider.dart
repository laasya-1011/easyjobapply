import 'dart:convert';
import 'package:admin_app/src/utils/firebase_constants.dart';
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
      saveDeviceToken(
          uid:
              uid); // how you generated apk//No need to generate here i use flutter run command to get the app debug//
    } else {
      // pay attention on what I am saying .. any apk for less complex app is more than 20 or 25 mb is not normal okay // your project lines of code or any other plugin is one of the minimum out of most of projects I have seen, now have you wondered why even facebook with that amount of code and things is till about only 50 mb ?yes sir many times,but thought that we need to reduce the size by using some other websiteds// good at least you noticed it // you should have asked me .. // now let me explain  this to you //
      updateDeviceToken(uid: uid);
    }
  }

// flutter minimum apk size is 7-8 mb normal hello world app
//the way you generated apk is not the proper way to generate the apk
// when we run the app it adds multiple plugins and tools with your app for debug this is why your apk is 150 mb plus//

// now let's see how to generate apk
// flutter build apk (generate debug apk means few permissions are added as default like internet) apk will harldy be 15 mb // this is the p still looks 90 mb but we'll fix soon. t/omorrow//ok sir
//flutter build apk --release (proper apk that is used to sent to playstore)//got it sir // 13 mb

// ping me when it's done//ok sir
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
    await db.collection("userFcmToken").doc(uid).get().then((value) async {
      token = await value['fcmToken'];
      print(value['fcmToken']);
      return value['fcmToken'];
    });
    return token;
  }

  // get multiple fcmtoken at a time based on uid list //
  Future<List<String>> getAllMemberFcm(
      {@required List<String> membersUid}) async {
    List<String> _membersFcm = [];
    try {
      for (var item in membersUid) {
        await db.collection("userFcmToken").doc(item).get().then((value) {
          var token = value['fcmToken'].toString();

          //  print("token : ${value['fcmToken']}");
          _membersFcm.add(token);
        });
      }
      return _membersFcm;
    } catch (e) {
      print("Token error: $e");
      return _membersFcm;
    }
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
          'key=AAAAh9wigpc:APA91bGfIU7ZDZOMzD54y3H0PC10UxAJoptdNa7OuDOiMrIRbFeK0AX1MimiGC-LeVKm7Ohw4tXSEJaOUZf1vvAaxgS_-8GEzdg7eQEKZssXPCZg2FQa4gt1Laykh8YhyJGmORV5DcDi' // this is updated na//yes sir// i have changed it// okay
    };
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    if (response.statusCode == 200) {
      //perform a task
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
