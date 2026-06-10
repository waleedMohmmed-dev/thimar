import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class AddToCartParams extends Equatable {
  final String productId;
  final int amount;

  const AddToCartParams({required this.productId, required this.amount});

  @override
  List<Object?> get props => [productId, amount];
}

class AddToCartUseCase implements UseCase<void, AddToCartParams> {
  final HomeRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async {
    return repository.addToCart(params.productId, params.amount);
  }
}
