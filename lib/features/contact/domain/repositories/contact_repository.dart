import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

abstract class ContactRepository {
  Future<Either<Failure, void>> submitContact({
    required String name,
    required String phone,
    required String message,
  });
}
