import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:thimar/features/contact/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> submitContact({
    required String name,
    required String phone,
    required String message,
  }) async {
    try {
      await remoteDataSource.submitContact(
        name: name,
        phone: phone,
        message: message,
      );
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
