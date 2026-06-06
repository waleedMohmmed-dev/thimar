import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyRemoteDataSource {
  Future<PrivacyEntity> getPrivacy();
}

class PrivacyRemoteDataSourceImpl implements PrivacyRemoteDataSource {
  final ApiService _apiService;

  PrivacyRemoteDataSourceImpl(this._apiService);

  @override
  Future<PrivacyEntity> getPrivacy() async {
    final response = await _apiService.get(Endpoints.policy);
    final content = response['data']?['content']?.toString() ??
        response['data']?.toString() ?? '';
    return PrivacyEntity(content: content);
  }
}
