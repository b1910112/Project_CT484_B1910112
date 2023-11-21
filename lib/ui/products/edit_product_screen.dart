// Import các gói cần thiết từ Flutter và provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import model Product và các utility functions từ các file khác
import '../../models/product.dart';
import '../shared/dialog_utils.dart';
import 'products_manager.dart';

// EditProductScreen là một StatefulWidget để hiển thị màn hình chỉnh sửa sản phẩm
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  // Hàm khởi tạo nhận một đối tượng Product, hoặc null nếu tạo sản phẩm mới
  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        price: 0,
        description: '',
        imageUrl: '',
      );
    } else {
      this.product = product;
    }
  }

  late final Product product;

  // Override createState để tạo ra một trạng thái mới
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

// _EditProductScreenState là trạng thái của EditProductScreen
class _EditProductScreenState extends State<EditProductScreen> {
  // Controllers và FocusNodes cho các trường nhập liệu và hình ảnh
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;

  // Kiểm tra tính hợp lệ của URL hình ảnh
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
        (value.endsWith('.png') ||
            value.endsWith('.jpg') ||
            value.endsWith('.jpeg'));
  }

  // Hàm được gọi khi StatefulWidget được tạo ra
  @override
  void initState() {
    // Lắng nghe sự kiện thay đổi focus của trường nhập URL hình ảnh
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        // Ảnh hợp lệ -> vẽ lại màn hình để hiện preview
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;
    super.initState();
  }

  // Hàm được gọi khi StatefulWidget bị huỷ
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  // Hàm xử lý khi người dùng lưu biểu mẫu
  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy đối tượng ProductsManager từ Provider để thêm hoặc cập nhật sản phẩm
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.id != null) {
        await productsManager.updateProduct(_editedProduct);
      } else {
        await productsManager.addProduct(_editedProduct);
      }
    } catch (error) {
      // Hiển thị dialog thông báo lỗi nếu có lỗi xảy ra
      await showErrorDialog(context, 'Something went wrong');
    }
    setState(() {
      _isLoading = false;
    });

    // Đóng màn hình chỉnh sửa sau khi lưu thành công
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildTitleField(),
                    buildPriceField(),
                    buildDescriptionField(),
                    buildProductPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  // Hàm tạo TextFormField cho trường tiêu đề sản phẩm
  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }

  // Hàm tạo TextFormField cho trường giá sản phẩm
  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a price.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a number greater than zero';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
      },
    );
  }

  // Hàm tạo TextFormField cho trường mô tả sản phẩm
  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  // Hàm tạo giao diện xem trước sản phẩm
  Widget buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: buildImageURLField(),
        ),
      ],
    );
  }

  // Hàm tạo TextFormField cho trường nhập URL ảnh sản phẩm
  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }
}
