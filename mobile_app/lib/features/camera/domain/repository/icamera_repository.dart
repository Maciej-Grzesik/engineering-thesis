import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/camera/domain/entities/classification.dart';

abstract interface class ICameraRepository {
  Future<Either<Failure, Classification>> getClassification({
    required String b64Video,
  });
}
