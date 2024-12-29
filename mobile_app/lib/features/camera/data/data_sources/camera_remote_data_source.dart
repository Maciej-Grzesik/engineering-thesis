import 'package:mobile_app/features/camera/data/models/classification_model.dart';

abstract interface class ICameraRemoteDataSource {
  Future<ClassificationModel> getClassification({
    required String b64Video,
  });
}

class CameraRemoteDataSource implements ICameraRemoteDataSource {
  @override
  Future<ClassificationModel> getClassification({
    required String b64Video,
  }) async {
    try {
      // bedzie do napisania logika zapytan do api

      return ClassificationModel(word: "placeholder");
    } catch (e) {
      throw Exception("error_code_no_classification");
    }
  }
}
