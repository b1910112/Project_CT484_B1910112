// Import các gói cần thiết từ Flutter, provider và các widget khác
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cart/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../products/product_search_screen.dart';
import '../products/products_grid.dart';
import '../products/products_manager.dart';
import '../products/top_right_badge.dart';
import '../shared/app_drawer.dart';

// Enum để định nghĩa các tùy chọn lọc sản phẩm
enum FilterOptions { favorites, all }

// ProductsOverviewScreen là một StatefulWidget để hiển thị các sản phẩm
class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  // Override để tạo ra một trạng thái mới
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

// _ProductsOverviewScreenState là trạng thái của ProductsOverviewScreen
class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // ValueNotifier để theo dõi trạng thái chỉ hiển thị sản phẩm yêu thích hay tất cả sản phẩm
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;

  // Hàm khởi tạo, được gọi khi trạng thái được tạo
  @override
  void initState() {
    super.initState();
    // Khởi tạo Future để fetch dữ liệu sản phẩm từ ProductsManager
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh ứng dụng với tiêu đề 'MyShop' và các nút điều hướng
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          // Nút tìm kiếm
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Chuyển đến màn hình tìm kiếm sản phẩm
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          // Menu lọc sản phẩm và icon giỏ hàng
          buildProductFilterMenu(),
          buildShoppingCartIcon(),
        ],
      ),
      // Menu điều hướng bên trái
      drawer: const AppDrawer(),
      // Phần thân màn hình, sử dụng FutureBuilder để hiển thị dữ liệu sau khi đã fetch xong
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Sử dụng ValueListenableBuilder để cập nhật giao diện khi giá trị của _showOnlyFavorites thay đổi
            return ValueListenableBuilder<bool>(
              valueListenable: _showOnlyFavorites,
              builder: (context, onlyFavorites, child) {
                // Sử dụng ProductsGrid để hiển thị danh sách sản phẩm
                return ProductsGrid(onlyFavorites);
              },
            );
          }
          // Hiển thị CircularProgressIndicator trong khi đang fetch dữ liệu
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Widget hiển thị icon giỏ hàng với số lượng sản phẩm trong giỏ hàng
  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Chuyển đến màn hình giỏ hàng
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        );
      },
    );
  }

  // Widget xây dựng menu lọc sản phẩm
  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      // Callback khi người dùng chọn một tùy chọn từ menu
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          // Nếu chọn 'Only Favorite', chỉ hiển thị sản phẩm yêu thích
          _showOnlyFavorites.value = true;
        } else {
          // Nếu chọn 'Show All', hiển thị tất cả sản phẩm
          _showOnlyFavorites.value = false;
        }
      },
      // Icon cho menu
      icon: const Icon(
        Icons.more_vert,
      ),
      // Danh sách các tùy chọn trong menu
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorite'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}
