import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageclean/features/home/data/datasources/image_local_datasource.dart';
import 'package:imageclean/features/home/data/datasources/image_remote_datasource.dart';
import 'package:imageclean/features/home/data/exceptions/exceptions.dart';

import '../../domain/failures/failures.dart';
import '../../domain/repositories/image_repository.dart';
import '../../../../services/db_helper.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDatasource imageRemoteDatasource;
  final ImageLocalDatasource imageLocalDatasource;
  ImageRepositoryImpl(
      {required this.imageRemoteDatasource,
      required this.imageLocalDatasource});

  @override
  Future<Either<Failure, String>> uploadImage(XFile image,
      {String? apiUrl, bool isSync = false}) async {
    // Check internet connectivity
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      if (!isSync) {
        try {
          final result = await imageLocalDatasource.saveImageToLocalStorage(
            image,
          );
          return right(result);
        } on CacheExceptions catch (e) {
          return left(CacheFailure());
        } catch (e) {
          return left(GeneralFailure());
        }
      }
    } else {
      // Upload image to server
      try {
        final result = await imageRemoteDatasource.sendImageToApi(
          image,
          apiUrl: apiUrl,
        );
        return right(result);
      } on ServerException catch (e) {
        try {
          final result = await imageLocalDatasource.saveImageToLocalStorage(
            image,
          );
          return right(result);
        } on CacheExceptions catch (e) {
          return left(CacheFailure());
        } catch (e) {
          return left(GeneralFailure());
        }
      } catch (e) {
        return left(GeneralFailure());
      }
    }
    return right("Something else happened");
  }

  @override
  Future<int> delete(int id) async {
    return await DatabaseHelper.instance.delete(id);
  }

  @override
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await DatabaseHelper.instance.queryAllRows();
  }
}
