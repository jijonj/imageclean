import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imageclean/features/home/data/exceptions/exceptions.dart';

abstract class ImageRemoteDatasource {
  Future<String> sendImageToApi(XFile image, {String? apiUrl});
}

class ImageRemoteDatasourceImpl implements ImageRemoteDatasource {
  final http.Client client;
  ImageRemoteDatasourceImpl({required this.client});

  @override
  Future<String> sendImageToApi(XFile image, {String? apiUrl}) async {
    // Upload image to server
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl ?? 'http://10.0.2.2:5000/api/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse['message'];
    } else {
      throw ServerException();
    }
  }
}
