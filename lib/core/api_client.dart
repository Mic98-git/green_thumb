import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:green_thumb/config/global_variables.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      Response response =
          await _dio.post(url + ':3000/users/register', data: data);
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(url + ':3000/users/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getUser(String userId) async {
    try {
      Response response = await _dio.get(
        url + ':3000/users/' + userId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updateUser(String userId, Map<String, dynamic>? data) async {
    try {
      Response response =
          await _dio.put(url + ':3000/users/' + userId, data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> addNewProduct(Map<String, dynamic>? data) async {
    try {
      Response response = await _dio.post(url + ':3002/products', data: data);
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> getProducts() async {
    try {
      Response response = await _dio.get(
        url + ':3002/products',
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getProductsByList(List<String> products) async {
    try {
      Response response = await _dio
          .post(url + ':3002/products/list', data: {'products': products});
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getSellersProducts(String userId) async {
    try {
      Response response = await _dio.get(
        url + ':3002/products/' + userId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getProduct(String productId) async {
    try {
      Response response = await _dio.get(
        url + ':3002/products/' + productId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deleteProduct(String productId) async {
    try {
      Response response = await _dio.delete(
        url + ':3002/products/' + productId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updateProduct(
      String productId, Map<String, dynamic>? data) async {
    try {
      Response response =
          await _dio.put(url + ':3002/products/' + productId, data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updatePosition(
      Map<String, dynamic>? data, String idOrder) async {
    try {
      // _dio.options.headers["authorization"] = "";
      Response response =
          await _dio.put(url + ':3003/order/' + idOrder, data: data);
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> getCart(String cartId) async {
    try {
      Response response = await _dio.get(
        url + ':3003/cart/' + cartId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> addProductInCart(
      Map<String, dynamic>? data, String cartId, String productId) async {
    try {
      Response response = await _dio
          .post(url + ':3003/cart/' + cartId + '/' + productId, data: data);
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> deleteProductFromCart(String cartId, String productId) async {
    try {
      Response response = await _dio.delete(
        url + ':3003/cart/' + cartId + '/' + productId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deleteCart(String cartId) async {
    try {
      Response response = await _dio.delete(
        url + ':3003/cart/' + cartId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOrder(String orderId) async {
    try {
      Response response = await _dio.get(
        url + ':3003/order/' + orderId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getUserOrders(String userId) async {
    try {
      Response response = await _dio.get(
        url + ':3003/order/user/' + userId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getSellerOrders(String sellerId) async {
    try {
      Response response = await _dio.get(
        url + ':3003/order/seller/' + sellerId,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> addOrder(String userId, Map<String, dynamic>? data) async {
    try {
      Response response =
          await _dio.post(url + ':3003/order/' + userId, data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deliveredOrder(String orderId) async {
    try {
      Response response =
          await _dio.put(url + ':3003/order/delivered/' + orderId);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
  // Future<dynamic> getUserProfileData(String accessToken) async {
  //   try {
  //     Response response = await _dio.get(
  //       'https://api.loginradius.com/identity/v2/auth/account',
  //       queryParameters: {'apikey': "ApiSecret.apiKey"},
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //     return response.data;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }

  // Future<dynamic> updateUserProfile({
  //   required String accessToken,
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     Response response = await _dio.put(
  //       'https://api.loginradius.com/identity/v2/auth/account',
  //       data: data,
  //       queryParameters: {'apikey': "ApiSecret.apiKey"},
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //     return response.data;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }

  // Future<dynamic> logout(String accessToken) async {
  //   try {
  //     Response response = await _dio.get(
  //       'https://api.loginradius.com/identity/v2/auth/access_token/InValidate',
  //       queryParameters: {'apikey': "ApiSecret.apiKey"},
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //     return response.data;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }
}
