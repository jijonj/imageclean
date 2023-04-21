import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageclean/features/home/domain/failures/failures.dart';
import 'package:imageclean/features/home/domain/usecases/sync_image_usecases.dart';
import 'package:imageclean/services/db_helper.dart';
import '../../domain/usecases/upload_image_usecases.dart';

part 'image_event.dart';
part 'image_state.dart';

const generalFailureMessage = 'Ups, something gone wrong. Please try again!';
const serverFailureMessage = 'Ups, API Error. please try again!';
const cacheFailureMessage = 'Ups, chache failed. Please try again!';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final UploadImageUsecase uploadImageUsecase;
  final SyncImageUsecase syncImageUsecase;
  ImageBloc({required this.uploadImageUsecase, required this.syncImageUsecase})
      : super(ImageInitial()) {
    on<SelectAndUploadImage>((event, emit) async {
      emit(ImageUploading());
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final message = await uploadImageUsecase.uploadImage(pickedImage,
            apiUrl: null, isSync: false);
        message.fold(
          (failure) =>
              emit(ImageUploadedFailure(_mapFailureToMessage(failure))),
          (message) => emit(
            ImageUploadedSuccess(
              message,
            ),
          ),
        );
      } else {
        emit(ImageUploadedFailure('No image selected.'));
      }
    });

    on<SyncImages>((event, emit) async {
      emit(ImageUploading());
      try {
        final unsyncedImages = await syncImageUsecase.queryAllRows();
        for (final imageRow in unsyncedImages) {
          final imagePath = imageRow[DatabaseHelper.columnImagePath];
          final apiUrl = imageRow[DatabaseHelper.columnApiUrl];
          final image = XFile(imagePath);
          await uploadImageUsecase.uploadImage(image,
              apiUrl: apiUrl, isSync: true);
          await syncImageUsecase.delete(imageRow[DatabaseHelper.columnId]);
        }
        emit(ImageUploadedSuccess('All images synced successfully.'));
      } catch (e) {
        emit(ImageUploadedFailure('Error syncing images: $e'));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }
}
