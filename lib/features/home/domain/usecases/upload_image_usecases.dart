import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../failures/failures.dart';
import '../repositories/image_repository.dart';

class UploadImageUsecase {
  final ImageRepository imageRepository;
  UploadImageUsecase({required this.imageRepository});

  Future<Either<Failure, String>> uploadImage(XFile image,
      {String? apiUrl, bool isSync = false}) {
    return imageRepository.uploadImage(image, apiUrl: apiUrl, isSync: isSync);
  }
}
