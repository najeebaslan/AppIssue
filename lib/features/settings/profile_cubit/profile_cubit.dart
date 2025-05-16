import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';

import '../../../core/networking/network_info.dart';
import '../../../core/networking/type_response.dart';
import '../../../core/services/services_locator.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.profileRepository,
    required this.userHelper,
    required this.firebaseFireStore,
    required this.networkInfo,
  }) : super(ProfileInitial());

  final FirebaseFirestore firebaseFireStore;
  final BaseProfileRepository profileRepository;
  final UserHelper userHelper;
  final NetworkInfo networkInfo;

  void getProfile(String userId) async {
    emit(LoadingGetProfileState());
    final currentUser = getIt.get<FirebaseAuth>().currentUser;
    if (isSignInUsingGoogle && !isClosed && currentUser != null) {
      emit(
        SuccessGetProfileState(profileModel: ProfileModel.adaptiveUser(currentUser)),
      );
    } else {
      final response = await profileRepository.getProfile(userId);
      if (response is Success && !isClosed) {
        emit(SuccessGetProfileState(profileModel: response.success!));
      } else if (response is Failure && !isClosed) {
        emit(ErrorGetProfileState(error: response.failure.validate()));
      }
    }
  }

  void updateProfile(UpdateProfileParameters parameters) async {
    emit(LoadingUpdateProfileState());

    final response = await profileRepository.updateProfile(parameters);
    if (response is Success) {
      await userHelper.saveUsername(parameters.name.validate());
      if (!isClosed) {
        emit(SuccessUpdateProfileState());
      }
    } else if (response is Failure && !isClosed) {
      emit(ErrorUpdateProfileState(error: response.failure.toString()));
    }
  }

  void updateImage(UpdateImageParameters parameters) async {
    emit(LoadingUpdateImageState());

    final response = await profileRepository.updateImage(parameters);
    if (response is Success) {
      await userHelper.saveImageUri(response.success.validate());
      if (!isClosed) {
        emit(SuccessUpdateImageState(response.success ?? ''));
      }
    } else if (response is Failure) {
      if (!isClosed) {
        emit(ErrorUpdateImageState(error: response.failure.toString()));
      }
    }
  }

  void deleteMyAccount({String? imageUri, required String password}) async {
    emit(LoadingDeleteAccountState());
    final response = await profileRepository.deleteMyAccount(imageUri, password);
    if (response is Success) {
      if (!isClosed) {
        emit(SuccessDeleteAccountState());
      }
    } else if (response is Failure) {
      if (!isClosed) {
        emit(ErrorDeleteAccountState(error: response.failure.toString()));
      }
    }
  }

  void refreshProfileView() => emit(RefreshProfileState());

  bool get isSignInUsingGoogle {
    final currentUser = getIt.get<FirebaseAuth>().currentUser;
    return currentUser?.providerData[0].providerId == 'google.com';
  }

  String adaptiveImageUri() {
    if (isSignInUsingGoogle) {
      //I use replaceAll for resize google image to hight quality
      return getIt.get<UserHelper>().getImageUri().replaceAll("s96-c", "s400-c");
    } else {
      return getIt.get<UserHelper>().getImageUri();
    }
  }
}
