import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/rate_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetProductRatesUseCase
    implements UseCase<List<RateEntity>, String> {
  final HomeRepository repository;

  GetProductRatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RateEntity>>> call(String productId) async {
    return repository.getProductRates(productId);
  }
}
