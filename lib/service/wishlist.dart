import 'package:dio/dio.dart';
import 'package:kopi_combi/utils/dio.dart';
import 'package:kopi_combi/utils/local_storage.dart';

class WihslistService {
  final local = LocalStorage();

  Future myWishlist() async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      Response res = await dioInstance()
          .get('wishlist', options: Options(headers: headers));
      Map<String, dynamic> data = await res.data;
      return data['data'];
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future productOnWishlist(int productId) async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      Response res = await dioInstance().get('wishlist-by-product',
          queryParameters: {'product_id': productId},
          options: Options(headers: headers));
      Map<String, dynamic> data = await res.data;
      return data['data'] == null ? false : true;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future addToWishlist(int productId) async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      Response res = await dioInstance().post('wishlist',
          data: {'product_id': productId}, options: Options(headers: headers));
      Map<String, dynamic> data = await res.data;
      return data['data']['product_id'] == null ? false : true;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future removeMyWishlist(int wishlistId) async {
    try {
      Map<String, String>? headers = await local.authorizationHeader();
      Response res = await dioInstance()
          .delete('wishlist/$wishlistId', options: Options(headers: headers));
      Map<String, dynamic> data = await res.data;
      return data['data']['product_id'] == null ? false : true;
    } on DioException {
      rethrow;
    }
  }
}
