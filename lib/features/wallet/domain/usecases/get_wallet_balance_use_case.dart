import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletBalanceUseCase implements UseCase<double, NoParams> {
  final WalletRepository repository;

  GetWalletBalanceUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return repository.getWalletBalance();
  }
}
