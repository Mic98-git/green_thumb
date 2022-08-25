import 'dart:developer';
import 'dart:ffi';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      Response response = await _dio
          .post('http://valeriobob.ddns.net:3000/users/register', data: data);
      // .post('http://10.0.2.2:3000/users/register', data: data);
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response =
          await _dio.post('http://valeriobob.ddns.net:3000/users/login', data: {
        // await _dio.post('http://10.0.2.2:3000/users/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> addNewProduct(Map<String, dynamic>? data) async {
    try {
      Response response =
          await _dio.post('http://valeriobob.ddns.net:3002/products', data: data
              // await _dio.post('http://10.0.2.2:3000/users/login', data: data
              );
      return response.data;
    } on DioError catch (e) {
      log(e.toString());
      return e.response!.data;
    }
  }

  Future<dynamic> getUser(String userId) async {
    try {
      Response response = await _dio.get(
        'http://valeriobob.ddns.net:3000/users/' + userId,
      );
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
