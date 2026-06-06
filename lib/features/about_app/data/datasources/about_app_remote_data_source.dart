import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/about_app/domain/entities/about_app_entity.dart';

abstract class AboutAppRemoteDataSource {
  Future<AboutAppEntity> getAbout();
}

class AboutAppRemoteDataSourceImpl implements AboutAppRemoteDataSource {
  final ApiService _apiService;

  AboutAppRemoteDataSourceImpl(this._apiService);

  @override
  Future<AboutAppEntity> getAbout() async {
    final response = await _apiService.get(Endpoints.about);
    final data = response['data'];
    return AboutAppEntity(
      phone: data?['phone']?.toString() ?? '',
      email: data?['email']?.toString() ?? '',
      address: data?['address']?.toString() ?? '',
      terms: data?['terms']?.toString() ?? '',
    );
  }
}
