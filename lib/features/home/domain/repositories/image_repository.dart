import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../failures/failures.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> uploadImage(XFile image,
      {String? apiUrl, bool isSync});
  Future<int> delete(int id);
  Future<List<Map<String, dynamic>>> queryAllRows();
}
