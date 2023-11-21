import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_token.dart';
import '../models/product.dart';
import 'firebase_service.dart';

class ProductsService extends FirebaseService {
  // Constructor với AuthToken tùy chọn để có thể truyền thông tin xác thực từ Auth Service
  ProductsService([AuthToken? authToken]) : super(authToken);

  // Phương thức lấy danh sách sản phẩm từ Firebase Realtime Database
  Future<List<Product>> fetchProducts([bool filterByUser = false]) async {
    final List<Product> products = [];

    try {
      final filters = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final productsUrl = Uri.parse('$databaseUrl/products.json?auth=$token&$filters');
      final response = await http.get(productsUrl);
      final productsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(productsMap['error']);
        return products;
      }

      final userFavoritesUrl = Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesRespone = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesRespone.body);

      productsMap.forEach((productId, product) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[productId] ?? false);
        products.add(
          Product.fromJson({
            'id': productId,
            ...product,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }

  // Phương thức thêm sản phẩm mới vào Firebase Realtime Database
  Future<Product?> addProduct(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/products.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          product.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return product.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Phương thức cập nhật thông tin sản phẩm trên Firebase Realtime Database
  Future<bool> updateProduct(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/products/${product.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error){
      print(error);
      return false;
    }
  }

  // Phương thức xóa sản phẩm khỏi Firebase Realtime Database
  Future<bool> deleteProduct(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/products/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Phương thức lưu trạng thái ưa thích của sản phẩm
  Future<bool> saveFavoriteStatus(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/userFavorites/$userId/${product.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          product.isFavorite,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Phương thức lấy danh sách sản phẩm từ Firebase Realtime Database
  Future<List<Product>> fetchProductsFromDatabase() async {
    final List<Product> products = [];

    try {
      final productsUrl = Uri.parse('$databaseUrl/products.json?auth=$token');
      final response = await http.get(productsUrl);
      final productsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(productsMap['error']);
        return products;
      }

      final userFavoritesUrl = Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      productsMap.forEach((productId, product) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[productId] ?? false);
        products.add(
          Product.fromJson({
            'id': productId,
            ...product,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }

  // Phương thức tìm kiếm sản phẩm dựa trên query
  Future<List<Product>> searchProducts(String query) async {
    final List<Product> searchResults = [];

    try {
      final List<Product> products = await fetchProductsFromDatabase();

      if (products.isEmpty) {
        return searchResults;
      }

      final url = Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesRespone = await http.get(url);
      final userFavoritesMap = json.decode(userFavoritesRespone.body);

      products.forEach((Product product) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[product.id] ?? false);

        final searchedProduct = product.copyWith(isFavorite: isFavorite);

        // Kiểm tra xem sản phẩm có phù hợp với query không
        if (searchedProduct.title.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(searchedProduct);
        }
      });

      return searchResults;
    } catch (error) {
      print(error);
      return searchResults;
    }
  }
}
