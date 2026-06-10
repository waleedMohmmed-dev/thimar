import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class ApplyCouponParams extends Equatable {
  final String code;
  const ApplyCouponParams({required this.code});
  @override
  List<Object?> get props => [code];
}

class ApplyCouponUseCase
    implements UseCase<Map<String, dynamic>, ApplyCouponParams> {
  final HomeRepository repository;

  ApplyCouponUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ApplyCouponParams params,
  ) async {
    return repository.applyCoupon(params.code);
  }
}
