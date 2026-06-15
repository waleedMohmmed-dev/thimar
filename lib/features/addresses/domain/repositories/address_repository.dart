import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, AddressEntity>> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  });
  Future<Either<Failure, AddressEntity>> updateAddress({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  });
  Future<Either<Failure, void>> deleteAddress(int id);
}
