import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/error/exception.dart';
import 'package:mobile_app/features/camera/data/data_sources/camera_remote_data_source.dart';
import 'package:mobile_app/features/camera/domain/entities/classification.dart';
import 'package:mobile_app/features/camera/domain/repository/icamera_repository.dart';

class CameraRepository implements ICameraRepository {
  final ICameraRemoteDataSource remoteDataSource;

  CameraRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Classification>> getClassification({
    required String b64Video,
  }) async {
    try {
      final classification = await remoteDataSource.getClassification(
        b64Video: b64Video,
      );
      return right(classification);
    } on ServiceException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("An error has occured ${e.toString()}"));
    }
  }
}
