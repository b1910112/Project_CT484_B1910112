// Import các gói cần thiết từ Flutter và Dart
import 'package:flutter/foundation.dart';

// Import các model và service liên quan
import '../../models/auth_token.dart';
import '../../models/product.dart';
import '../../services/products_service.dart';

// Lớp quản lý sản phẩm
class ProductsManager with ChangeNotifier {
  // Danh sách các sản phẩm
  List<Product> _items = [];

  // Dịch vụ quản lý sản phẩm
  final ProductsService _productsService;

  // Hàm khởi tạo nhận AuthToken để xác định quyền truy cập
  ProductsManager([AuthToken? authToken])
      : _productsService = ProductsService(authToken);

  // Setter cho AuthToken
  set authToken(AuthToken? authToken) {
    _productsService.authToken = authToken;
  }

  // Phương thức để fetch danh sách sản phẩm từ dịch vụ
  Future<void> fetchProducts([bool filterByUser = false]) async {
    _items = await _productsService.fetchProducts(filterByUser);
    notifyListeners();
  }

  // Phương thức để thêm một sản phẩm mới
  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  // Phương thức để cập nhật một sản phẩm
  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (await _productsService.updateProduct(product)) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  // Phương thức để xóa một sản phẩm
  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      Product? existingProduct = _items.removeAt(index);
      notifyListeners();

      if (!await _productsService.deleteProduct(id)) {
        _items.insert(index, existingProduct);
        notifyListeners();
      }
    }
  }

  // Phương thức để chuyển đổi trạng thái yêu thích của một sản phẩm
  Future<void> toggleFavoriteStatus(Product product) async {
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;

    if (!await _productsService.saveFavoriteStatus(product)) {
      product.isFavorite = savedStatus;
      notifyListeners();
    }
  }

  // Getter để lấy số lượng sản phẩm
  int get itemCount {
    return _items.length;
  }

  // Getter để lấy danh sách sản phẩm
  List<Product> get items {
    return [..._items];
  }

  // Getter để lấy danh sách sản phẩm yêu thích
  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  // Phương thức để tìm sản phẩm theo ID
  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  // Tìm kiếm sản phẩm
  List<Product> _searchResults = [];

  // Getter để lấy danh sách kết quả tìm kiếm
  List<Product> get searchResults {
    return _searchResults;
  }

  // Phương thức để thực hiện tìm kiếm sản phẩm
  Future<void> searchProducts(String query) async {
    _searchResults = await _productsService.searchProducts(query);
    notifyListeners();
  }
}
