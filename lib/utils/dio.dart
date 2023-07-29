import 'package:dio/dio.dart';
import 'package:kopi_combi/utils/constant.dart';

Dio dioInstance() {
  var dio = Dio(BaseOptions(
      // baseUrl: 'http://103.172.204.225/api/',
      baseUrl: '$serviceUrl/api/',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json'
      },
      responseType: ResponseType.json));
  return dio;
}
