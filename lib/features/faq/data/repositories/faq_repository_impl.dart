import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/faq/data/datasources/faq_remote_data_source.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';
import 'package:thimar/features/faq/domain/repositories/faq_repository.dart';

class FaqRepositoryImpl implements FaqRepository {
  final FaqRemoteDataSource remoteDataSource;

  FaqRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<FaqEntity>>> getFaqs() async {
    try {
      final faqs = await remoteDataSource.getFaqs();
      return Right(faqs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
