import '../repositories/image_repository.dart';

class SyncImageUsecase {
  final ImageRepository imageRepository;

  SyncImageUsecase({required this.imageRepository});
  Future<int> delete(int id) {
    return imageRepository.delete(id);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() {
    return imageRepository.queryAllRows();
  }
}
