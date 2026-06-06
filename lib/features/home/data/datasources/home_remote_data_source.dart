import 'package:thimar/features/home/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> searchProducts(String keyword);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(dynamic apiService);

  @override
  Future<List<ProductModel>> getProducts() async {
    return [];
  }

  @override
  Future<List<ProductModel>> searchProducts(String keyword) async {
    return [];
  }
}
