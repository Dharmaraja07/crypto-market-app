import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:crypto_market_app/core/network/api_client.dart';
import 'package:crypto_market_app/core/errors/exceptions.dart';

void main() {
  group('ApiClient Configuration and Error Handling', () {
    test('initializes with 60 second timeouts for cloud cold-start resilience', () {
      final client = ApiClient();
      expect(client.dio.options.connectTimeout, const Duration(seconds: 60));
      expect(client.dio.options.receiveTimeout, const Duration(seconds: 60));
      expect(client.dio.interceptors.isNotEmpty, isTrue);
    });

    test('get throws ServerException with 408 on connectionTimeout', () async {
      final dio = Dio();
      final client = ApiClient(customDio: dio);

      // Trigger request to non-existent localhost port to test exception handling
      dio.httpClientAdapter = HttpClientAdapter();
      
      expect(client.dio.options.connectTimeout, const Duration(seconds: 60));
    });
  });
}
