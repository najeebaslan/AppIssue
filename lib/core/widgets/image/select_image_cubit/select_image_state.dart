part of 'select_image_cubit.dart';

class SelectImageState {
  const SelectImageState();
}

class SelectImageInitial extends SelectImageState {}

class OnPickImage extends SelectImageState {
  OnPickImage({required this.file});
  final File? file;
}

