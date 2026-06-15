import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/domain/repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return repository.deleteAddress(id);
  }
}
