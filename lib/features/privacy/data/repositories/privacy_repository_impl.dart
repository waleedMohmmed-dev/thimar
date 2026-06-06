import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/privacy/data/datasources/privacy_remote_data_source.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';
import 'package:thimar/features/privacy/domain/repositories/privacy_repository.dart';

class PrivacyRepositoryImpl implements PrivacyRepository {
  final PrivacyRemoteDataSource remoteDataSource;

  PrivacyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PrivacyEntity>> getPrivacy() async {
    try {
      final privacy = await remoteDataSource.getPrivacy();
      return Right(privacy);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
