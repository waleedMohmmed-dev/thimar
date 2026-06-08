import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetFavoriteIdsUseCase implements UseCase<Set<String>, NoParams> {
  final HomeRepository repository;

  GetFavoriteIdsUseCase(this.repository);

  @override
  Future<Either<Failure, Set<String>>> call(NoParams params) async {
    return repository.getFavoriteIds();
  }
}
