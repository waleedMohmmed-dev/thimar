import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class DeleteCartItemParams extends Equatable {
  final String itemId;

  const DeleteCartItemParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class DeleteCartItemUseCase
    implements UseCase<void, DeleteCartItemParams> {
  final HomeRepository repository;

  DeleteCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCartItemParams params) async {
    return repository.deleteCartItem(params.itemId);
  }
}
