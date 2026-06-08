import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';

abstract class ContactRemoteDataSource {
  Future<void> submitContact({
    required String name,
    required String phone,
    required String message,
  });
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ApiService _apiService;

  ContactRemoteDataSourceImpl(this._apiService);

  @override
  Future<void> submitContact({
    required String name,
    required String phone,
    required String message,
  }) async {
    await _apiService.post(
      Endpoints.contact,
      body: {'name': name, 'phone': phone, 'message': message},
    );
  }
}
