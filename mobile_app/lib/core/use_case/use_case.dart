import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';

abstract interface class UseCase<SuccesType, Params> {
  Future<Either<Failure, SuccesType>> call(Params params);
}