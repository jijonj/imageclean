part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageUploading extends ImageState {}

class ImageUploadedSuccess extends ImageState {
  final String message;

  ImageUploadedSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ImageUploadedFailure extends ImageState {
  final String message;

  ImageUploadedFailure(this.message);

  @override
  List<Object> get props => [message];
}
