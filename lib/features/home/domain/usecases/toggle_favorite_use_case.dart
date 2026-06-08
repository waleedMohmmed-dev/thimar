import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class ToggleFavoriteUseCase {
  final HomeRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId, bool isAdding) {
    return repository.toggleFavorite(productId, isAdding);
  }
}
