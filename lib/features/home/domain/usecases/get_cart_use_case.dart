import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/cart_item_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetCartUseCase implements UseCase<List<CartItemEntity>, NoParams> {
  final HomeRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) async {
    return repository.getCart();
  }
}
