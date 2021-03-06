import 'package:dio/dio.dart';


// base url : https://newsapi.org/
// url : v2/top-headlines?
// queries : country=eg&apiKey=e81dd9364f7046a8895a7ecb2280094c

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map <String, dynamic>? query,
    String lang = 'en',
    dynamic token,
  }) async
  {
    dio!.options.headers = {
      'content-Type' : 'application/json',
      'lang': lang,
        'Authorization': token,
      };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map <String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang ='en',
    String? token,
  }) async
  {
    dio!.options.headers = {
      'content-Type' : 'application/json',
        'lang': lang,
        'Authorization': token,
      };
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map <String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang ='en',
    String? token,
  }) async
  {
    dio!.options.headers = {
      'content-Type' : 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}