import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences? prefs;

  ApiClient({Dio? customDio, this.prefs}) : dio = customDio ?? Dio() {
    _init();
  }

  void _init() {
    String? customUrl = prefs?.getString('custom_backend_url');
    // If an old local testing URL was saved, clear it to use the new live Render cloud URL
    if (customUrl != null && (customUrl.contains('localhost') || customUrl.contains('10.80.130') || customUrl.contains('10.0.2.2') || customUrl.contains('10.253.160'))) {
      prefs?.remove('custom_backend_url');
      customUrl = null;
    }
    final baseUrl = customUrl != null && customUrl.isNotEmpty
        ? customUrl
        : ApiConstants.defaultBaseUrl;

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Automatic retry logic for timeouts and transient connection errors (e.g., Render free tier cold-start)
          final isTimeout = error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.connectionError;

          final isTransientServerStatus = error.response != null &&
              (error.response!.statusCode == 502 ||
               error.response!.statusCode == 503 ||
               error.response!.statusCode == 504 ||
               error.response!.statusCode == 408);

          final requestOptions = error.requestOptions;
          final retryCount = (requestOptions.extra['retry_count'] as int?) ?? 0;
          const maxRetries = 2;

          if ((isTimeout || isTransientServerStatus) && retryCount < maxRetries) {
            requestOptions.extra['retry_count'] = retryCount + 1;
            // Short backoff delay before retrying while the container finishes booting up
            await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
            try {
              final response = await dio.fetch(requestOptions);
              return handler.resolve(response);
            } catch (e) {
              if (e is DioException) {
                return handler.next(e);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
    prefs?.setString('custom_backend_url', newBaseUrl);
  }

  String get currentBaseUrl => dio.options.baseUrl;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      final body = response.data;
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return body['data'];
      }
      return body;
    } else {
      throw ServerException('Request failed with status: ${response.statusCode}', response.statusCode);
    }
  }

  ServerException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException('Server response timed out. The cloud server may be waking up from sleep. Please try again.', 408);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Server error ($statusCode)';
        if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        } else if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
          message = 'Cloud server is starting up or temporarily unavailable ($statusCode). Please try again in a moment.';
        }
        return ServerException(message, statusCode);
      case DioExceptionType.connectionError:
        return const ServerException('Cannot connect to backend server. The cloud service may be waking up, please try again.', 503);
      default:
        return ServerException(error.message ?? 'Unknown network error occurred');
    }
  }
}
