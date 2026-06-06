import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/about_app/data/datasources/about_app_remote_data_source.dart';
import 'package:thimar/features/about_app/domain/entities/about_app_entity.dart';
import 'package:thimar/features/about_app/domain/repositories/about_app_repository.dart';

class AboutAppRepositoryImpl implements AboutAppRepository {
  final AboutAppRemoteDataSource remoteDataSource;

  AboutAppRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AboutAppEntity>> getAbout() async {
    try {
      final about = await remoteDataSource.getAbout();
      return Right(about);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
