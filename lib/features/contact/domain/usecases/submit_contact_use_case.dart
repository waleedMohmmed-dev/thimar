import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/contact/domain/repositories/contact_repository.dart';

class SubmitContactUseCase {
  final ContactRepository repository;

  SubmitContactUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String phone,
    required String message,
  }) async {
    return await repository.submitContact(
      name: name,
      phone: phone,
      message: message,
    );
  }
}
