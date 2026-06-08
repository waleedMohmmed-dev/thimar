import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class AddProductRateUseCase
    implements UseCase<void, AddProductRateParams> {
  final HomeRepository repository;

  AddProductRateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProductRateParams params) async {
    return repository.addProductRate(
      params.productId,
      params.value,
      params.comment,
    );
  }
}

class AddProductRateParams extends Equatable {
  final String productId;
  final int value;
  final String comment;

  const AddProductRateParams({
    required this.productId,
    required this.value,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, value, comment];
}
