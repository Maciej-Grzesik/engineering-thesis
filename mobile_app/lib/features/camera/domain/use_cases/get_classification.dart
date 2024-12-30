import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/camera/domain/repository/icamera_repository.dart';

import '../entities/classification.dart';

class GetClassification implements UseCase<Classification, VideoDataParams> {
  final ICameraRepository _cameraRepository;

  GetClassification(this._cameraRepository);

  @override
  Future<Either<Failure, Classification>> call(params) async {
    return await _cameraRepository.getClassification(
      b64Video: params.b64Video,
    );
  }
}

class VideoDataParams extends Equatable {
  final String b64Video;

  const VideoDataParams({
    required this.b64Video,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
