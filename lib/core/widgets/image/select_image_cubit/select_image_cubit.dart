import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'select_image_state.dart';

class SelectImageCubit extends Cubit<SelectImageState> {
  SelectImageCubit() : super(SelectImageInitial());
  static SelectImageCubit get(BuildContext context) => BlocProvider.of(context);
  File? file;
  Future<void> pickImagesFromGallery(BuildContext context) async {
    try {
      final pickedImages = await ImagePicker().pickImage(
        imageQuality: 80,
        source: ImageSource.gallery,
      );

      if (pickedImages != null) {
        file = File(pickedImages.path);
      }
      emit(OnPickImage(file: file));
    } catch (e) {
      if (context.mounted) {
        await onThrowErrorPermission(context);
      }
    }
  }

  Future<void> pickImagesFromCamera(BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedImage != null) {
        file = File(pickedImage.path);
        emit(OnPickImage(file: file));
      }
    } catch (e) {
      if (context.mounted) {
        await onThrowErrorPermission(context);
      }
    }
  }

  Future<void> onThrowErrorPermission(BuildContext context) async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      debugPrint('تم الرفض');
    } else {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
            title: Text('notAllowedPermissionPhotos'.tr()),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('cancel'.tr()),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('setting'.tr()),
              )
            ],
            content: Text('allowedPermissionPhotos'.tr()),
          ),
        );
      }
    }
  }

  void clearImage() => file = null;

  void setState() => emit(OnPickImage(file: file));
}
