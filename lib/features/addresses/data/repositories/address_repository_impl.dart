import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/data/datasources/address_remote_data_source.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/addresses/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();
      return Right(addresses.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    try {
      final address = await remoteDataSource.addAddress(
        type: type,
        phone: phone,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
      );
      return Right(address.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    try {
      final address = await remoteDataSource.updateAddress(
        id: id,
        type: type,
        phone: phone,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
      );
      return Right(address.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(int id) async {
    try {
      await remoteDataSource.deleteAddress(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
