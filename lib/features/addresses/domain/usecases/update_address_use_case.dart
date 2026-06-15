import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/addresses/domain/repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    return repository.updateAddress(
      id: id,
      type: type,
      phone: phone,
      description: description,
      location: location,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
    );
  }
}
