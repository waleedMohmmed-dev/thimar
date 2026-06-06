import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';

abstract class FaqRemoteDataSource {
  Future<List<FaqEntity>> getFaqs();
}

class FaqRemoteDataSourceImpl implements FaqRemoteDataSource {
  final ApiService _apiService;

  FaqRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<FaqEntity>> getFaqs() async {
    final response = await _apiService.get(Endpoints.faqs);
    final List data = response['data'] ?? [];
    return data.map((json) => FaqEntity(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
    )).toList();
  }
}
