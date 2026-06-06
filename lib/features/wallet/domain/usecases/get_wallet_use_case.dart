import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_entity.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletUseCase implements UseCase<WalletEntity, NoParams> {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(NoParams params) async {
    return repository.getWallet();
  }
}
