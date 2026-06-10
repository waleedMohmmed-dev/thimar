import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class UpdateCartItemParams extends Equatable {
  final String itemId;
  final int amount;

  const UpdateCartItemParams({required this.itemId, required this.amount});

  @override
  List<Object?> get props => [itemId, amount];
}

class UpdateCartItemUseCase
    implements UseCase<void, UpdateCartItemParams> {
  final HomeRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return repository.updateCartItem(params.itemId, params.amount);
  }
}
