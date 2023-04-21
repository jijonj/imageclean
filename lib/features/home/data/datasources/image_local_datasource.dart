import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imageclean/features/home/data/exceptions/exceptions.dart';
import 'package:imageclean/services/db_helper.dart';
import 'package:path_provider/path_provider.dart';

abstract class ImageLocalDatasource {
  Future<String> saveImageToLocalStorage(XFile image);
}

class ImageLocalDatasourceImpl implements ImageLocalDatasource {
  @override
  Future<String> saveImageToLocalStorage(XFile image) async {
    // Save image to local storage
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final localImagePath = '${appDocDir.path}/${image.name}';
      await image.saveTo(localImagePath);

      // Save image path and API URL to the database
      await DatabaseHelper.instance.insert({
        DatabaseHelper.columnImagePath: localImagePath,
        DatabaseHelper.columnApiUrl: 'http://10.0.2.2:5000/api/upload',
      });
    } catch (e) {
      throw CacheExceptions();
    }
    return 'No internet connection. Image saved locally.';
  }
}
