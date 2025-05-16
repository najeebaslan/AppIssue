import 'package:firebase_auth/firebase_auth.dart';
import 'package:issue/core/extensions/string_extension.dart';

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
      name: map['name'] as String,
      email: map['email'] as String,
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
