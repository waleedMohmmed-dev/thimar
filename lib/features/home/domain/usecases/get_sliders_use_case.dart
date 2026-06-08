import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetSlidersUseCase implements UseCase<List<String>, NoParams> {
  final HomeRepository repository;

  GetSlidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return repository.getSliders();
  }
}
