import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../core/constants/default_settings.dart';
import '../../core/helpers/helper_user.dart';
import '../../core/networking/network_info.dart';
import '../../core/networking/type_response.dart';
import '../../core/services/services_locator.dart';
import 'profile_repository.dart';

class SyncOldUsersRepository {
  void syncOldUserDataToFireStoreIfNotExists({required User? currentUser}) async {
    if (await getIt.get<NetworkInfo>().isConnected) {
      if (_shouldSync(currentUser)) {
        final response = await getIt<ProfileRepositoryImpl>().isUserExisted(currentUser!.uid);
        if (response is Failure) {
          await _syncUser(currentUser);
        }
      }
    }
  }

  Future<void> _syncUser(User currentUser) async {
    try {
      final getUserNameLocally = getIt.get<UserHelper>().getUsername();
      await getIt
          .get<FirebaseFirestore>()
          .collection(DefaultSettings.nameCollectionUsersInFirebase)
          .doc(currentUser.uid)
          .set({'name': getUserNameLocally, 'email': currentUser.email});
      getIt.get<UserHelper>().saveIsUserSyncAccount(true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool _shouldSync(User? currentUser) {
    return isSignInUsingGoogle == false &&
        currentUser != null &&
        getIt.get<UserHelper>().getIsUserSyncAccount() == false;
  }

  bool get isSignInUsingGoogle {
    final currentUser = getIt.get<FirebaseAuth>().currentUser;
    return currentUser!.providerData[0].providerId == 'google.com';
  }
}
