import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/addresses/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call() async {
    return repository.getAddresses();
  }
}
