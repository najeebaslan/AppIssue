import 'package:firebase_auth/firebase_auth.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/services/services_locator.dart';

class ProfileModel {
  final String name;
  final String email;

  final String? profileImage;
  ProfileModel({
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? getIt.get<FirebaseAuth>().currentUser?.displayName,
      email: map['email'] ?? getIt.get<FirebaseAuth>().currentUser?.email,
      profileImage: map['profileImage'],
    );
  }
  factory ProfileModel.adaptiveUser(User user) {
    return ProfileModel(
      name: user.displayName.validate(),
      email: user.email.validate(),
      profileImage: user.photoURL.validate(),
    );
  }
}
