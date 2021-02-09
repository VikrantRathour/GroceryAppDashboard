import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_dashboard/models/cloud_storage_result.dart';

class CloudStorageSerice {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
  }) async {
    var imageFileName =
        imageToUpload.path + DateTime.now().millisecondsSinceEpoch.toString();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (downloadUrl != null) {
      var url = downloadUrl.toString();
      return CloudStorageResult(imageUrl: url, imageFileName: imageFileName);
    }

    return null;
  }
}
