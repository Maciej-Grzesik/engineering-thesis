import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/camera/data/models/classification_model.dart';

abstract interface class ICameraRemoteDataSource {
  Future<ClassificationModel> getClassification({
    required String b64Video,
  });
}

class CameraRemoteDataSource implements ICameraRemoteDataSource {
  final http.Client client;

  CameraRemoteDataSource(
    this.client,
  );

  @override
  Future<ClassificationModel> getClassification({
    required String b64Video,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('http://192.168.0.9:6000/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'video': b64Video,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ClassificationModel.fromJson(data);
      } else {
        throw Exception('error_code_no_classification');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
