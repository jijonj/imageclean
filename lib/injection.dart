import 'package:get_it/get_it.dart';
import 'package:imageclean/features/home/data/datasources/image_local_datasource.dart';
import 'package:imageclean/features/home/data/datasources/image_remote_datasource.dart';
import 'package:imageclean/features/home/domain/usecases/sync_image_usecases.dart';
import 'package:imageclean/features/home/domain/usecases/upload_image_usecases.dart';
import 'features/home/application/bloc/image_bloc.dart';
import 'features/home/data/repositories/image_repository_impl.dart';
import 'features/home/domain/repositories/image_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I; // sl == Service Locator

Future<void> init() async {
  // ! externs
  sl.registerFactory(() => http.Client());

  // Registering the Image Datasources
  sl.registerFactory<ImageRemoteDatasource>(
      () => ImageRemoteDatasourceImpl(client: sl()));
  sl.registerFactory<ImageLocalDatasource>(() => ImageLocalDatasourceImpl());

  // Registering the Image Repository
  sl.registerFactory<ImageRepository>(() => ImageRepositoryImpl(
        imageLocalDatasource: sl(),
        imageRemoteDatasource: sl(),
      ));

  // Registering the Usecases
  sl.registerFactory<UploadImageUsecase>(
      () => UploadImageUsecase(imageRepository: sl()));
  sl.registerFactory(() => SyncImageUsecase(imageRepository: sl()));

  // Registering the Image Bloc
  sl.registerFactory<ImageBloc>(
      () => ImageBloc(uploadImageUsecase: sl(), syncImageUsecase: sl()));
}
