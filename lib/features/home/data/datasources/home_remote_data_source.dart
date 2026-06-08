import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/home/data/models/product_model.dart';
import 'package:thimar/features/home/data/models/rate_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> searchProducts(String keyword);
  Future<List<String>> getSliders();
  Future<Set<String>> getFavoriteIds();
  Future<List<ProductModel>> getFavoriteProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> toggleFavorite(String productId, bool isAdding);
  Future<List<RateModel>> getProductRates(String productId);
  Future<void> addProductRate(String productId, int value, String comment);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService _apiService;

  HomeRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _apiService.get(Endpoints.products);
    final List data = response['data'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String keyword) async {
    final response = await _apiService.get(
      Endpoints.products,
      params: {'search': keyword},
    );
    final List data = response['data'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<String>> getSliders() async {
    final response = await _apiService.get(Endpoints.sliders);
    final List data = response['data'] ?? [];
    return data.map((json) => json['media']?.toString() ?? '').toList();
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    final response = await _apiService.get(Endpoints.clientFavorites);
    final List data = response['data'] ?? [];
    return data.map((json) => json['id']?.toString() ?? '').toSet();
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts() async {
    final response = await _apiService.get(Endpoints.clientFavorites);
    final List data = response['data'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _apiService.get(Endpoints.productDetails(id));
    return ProductModel.fromJson(response['data']);
  }

  @override
  Future<void> toggleFavorite(String productId, bool isAdding) async {
    await _apiService.post(
      isAdding
          ? Endpoints.addToFavorite(productId)
          : Endpoints.removeFromFavorite(productId),
    );
  }

  @override
  Future<List<RateModel>> getProductRates(String productId) async {
    final response = await _apiService.get(Endpoints.productRates(productId));
    final List data = response['data'] ?? [];
    return data.map((json) => RateModel.fromJson(json)).toList();
  }

  @override
  Future<void> addProductRate(
    String productId,
    int value,
    String comment,
  ) async {
    await _apiService.post(
      Endpoints.addProductRate(productId),
      body: {'value': value, 'comment': comment},
    );
  }
}
