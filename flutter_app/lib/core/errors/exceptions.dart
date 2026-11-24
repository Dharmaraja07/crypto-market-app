class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message ($statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache exception']);

  @override
  String toString() => 'CacheException: $message';
}
