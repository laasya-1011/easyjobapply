import 'dart:io';

import 'package:easyjob/src/utils/firebase_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

Future<String> addFileToFirebase(
    {@required String filePath,
    @required String firebasePath,
    String fileType}) async {
  String url;
  File file = File(filePath);
  Reference ref =
      storage.ref().child("$firebasePath/${file.path.split("/").last.trim()}");
  UploadTask uploadTask =
      ref.putFile(file, SettableMetadata(contentType: fileType));
  await uploadTask.then((res) async {
    await res.ref.getDownloadURL();
    url = await res.ref.getDownloadURL();
    // notifyListeners();
    print(url);
    // return url;
  });
  return url;
}
