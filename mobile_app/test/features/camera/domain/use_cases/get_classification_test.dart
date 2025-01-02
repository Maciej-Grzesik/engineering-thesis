import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/camera/domain/repository/icamera_repository.dart';
import 'package:mobile_app/features/camera/domain/use_cases/get_classification.dart';
import 'package:mobile_app/features/camera/domain/entities/classification.dart';

class MockICameraRepository extends Mock implements ICameraRepository {}

void main() {
  late GetClassification useCase;
  late MockICameraRepository mockICameraRepository;

  setUp(() {
    mockICameraRepository = MockICameraRepository();
    useCase = GetClassification(mockICameraRepository);
  });

  const tVideoDataParams = VideoDataParams(b64Video: 'test_video');
  const tClassification = Classification(word: "test");

  test('should get classification from the repository', () async {
    when(() => mockICameraRepository.getClassification(
            b64Video: any(named: 'b64Video')))
        .thenAnswer((_) async => const Right(tClassification));

    final result = await useCase(tVideoDataParams);

    expect(result, const Right(tClassification));
    verify(() => mockICameraRepository.getClassification(
        b64Video: tVideoDataParams.b64Video));
    verifyNoMoreInteractions(mockICameraRepository);
  });

  test('should return failure when repository call is unsuccessful', () async {
    when(() => mockICameraRepository.getClassification(
            b64Video: any(named: 'b64Video')))
        .thenAnswer((_) async => Left(Failure('Server Failure')));

    final result = await useCase(tVideoDataParams);

    expect(result, Left(Failure('Server Failure')));
    verify(() => mockICameraRepository.getClassification(
        b64Video: tVideoDataParams.b64Video));
    verifyNoMoreInteractions(mockICameraRepository);
  });
}
