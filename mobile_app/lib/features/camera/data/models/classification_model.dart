import 'package:mobile_app/features/camera/domain/entities/classification.dart';

class ClassificationModel extends Classification {
  ClassificationModel({
    required super.word,
  });

  static ClassificationModel fromJson(Map<String, dynamic> json) {
    return ClassificationModel(
      word: json['word'],
    );
  }
}
