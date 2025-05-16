import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:issue/core/networking/type_response.dart';
import 'package:issue/core/services/services_locator.dart';

class UploadFiles {
  final FirebaseStorage _storage = getIt.get<FirebaseStorage>();
  SocketException noInternet = SocketException('noInternet'.tr());
  Duration durationTimeOut = const Duration(minutes: 3);
  Future<ResponseResult<String, String>> uploadImage(File imageFile) async {
    try {
      // Upload the image to Firebase Storage
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(imageFile)
          .timeout(
            durationTimeOut,
            onTimeout: () => throw noInternet,
          );

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL().timeout(
            durationTimeOut,
            onTimeout: () => throw noInternet,
          );

      return Success(downloadUrl);
    } catch (error) {
      debugPrint(error.toString());
      return Failure('Unknown error check image size or quality');
    }
  }
}
