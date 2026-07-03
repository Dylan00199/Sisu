class ApiClient {
  const ApiClient({this.baseUrl = 'http://localhost:8080/api'});

  final String baseUrl;

  Uri uri(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalized');
  }
}
