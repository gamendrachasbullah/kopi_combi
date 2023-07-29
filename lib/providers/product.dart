import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:kopi_combi/dto/cart.dart';
import 'package:kopi_combi/utils/dio.dart';
import 'package:kopi_combi/utils/local_storage.dart';

class ProductProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  // late ProductCartDTO _cart;
  // ProductCartDTO get cartProducts => _cart;
  // List<ProductDTO> _products = [];
  // List<ProductDTO> get products => _products;
  int _totalPrice = 0;
  int get totalPrice => _totalPrice;
  List<ProductCartDTO> checkoutProducts = [];
  final local = LocalStorage();

  addToCart(int id, String name, int quantity, int price, String imageUrl) {
    checkoutProducts.add(ProductCartDTO.fromJson({
      'id': id,
      'name': name,
      'quantity': quantity,
      'image': imageUrl,
      'price': price
    }));
    _totalPrice = _getTotalPrice();
    notifyListeners();
  }

  deleteFromCart(int index) {
    checkoutProducts.removeAt(index);
    _totalPrice = _getTotalPrice();
    notifyListeners();
  }

  resetCart() {
    checkoutProducts.clear();
    _totalPrice = 0;
    notifyListeners();
  }

  _getTotalPrice() {
    return checkoutProducts.fold(
        0, (sum, item) => sum + (item.quantity * item.price));
  }

  Future getProducts({query}) async {
    try {
      di.Response res =
          await dioInstance().get('products', queryParameters: query);
      Map<String, dynamic> result = await res.data;
      _count = result['data']['total'];
      // result['data']['data']
      // _products = ProductDTO.fromJson(json);
      return result['data']['data'];
    } on di.DioException catch (e) {
      return e.message;
    }
  }

  Future getDetailProduct(int id) async {
    try {
      di.Response res =
          await dioInstance().get('products', queryParameters: {'id': id});
      return await res.data['data'];
    } on di.DioException catch (e) {
      return e.message;
    }
  }

  Future getPopularProducts() async {
    try {
      di.Response res = await dioInstance().get('products/popular');
      Map<String, dynamic> result = await res.data;
      return result['data']['data'];
    } on di.DioException catch (e) {
      return e.message;
    }
  }

  Future<bool> checkout(String address) async {
    try {
      final data = CartDTO.fromJson({
        'items': checkoutProducts,
        'address': address,
        'total_price': totalPrice
      });
      Map<String, String>? headers = await local.authorizationHeader();

      await dioInstance().post('checkout',
          data: data.toJson(), options: di.Options(headers: headers));
      resetCart();
      return true;
    } on di.DioException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future transactions() async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      di.Response res = await dioInstance()
          .get('transactions', options: di.Options(headers: headers));
      return await res.data;
    } on di.DioException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }
}
