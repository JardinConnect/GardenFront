import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
  // TODO : Cracker le sujet de compatibilité entre les plateformes (mobile/desktop) pour la configuration de l'URL de base
  /// Permet de configurer l'URL de base via la variable set dans l'os de la raspy
  // static final String baseUrl = Platform.environment['API_BASE_URL'] ?? 'http://127.0.0.1:8000';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> _getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && includeAuth) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final headers = await _getHeaders(includeAuth: false);
    final body = jsonEncode({'refresh_token': refreshToken});

    Future<http.Response> send(String endpoint) {
      return http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body,
      );
    }

    http.Response response = await send('/auth/refresh-token');
    if (response.statusCode == 404 || response.statusCode == 405) {
      response = await send('/auth/refresh-token/');
    }

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await _storage.write(
        key: 'auth_token',
        value: responseData['access_token'],
      );
      await _storage.write(
        key: 'refresh_token',
        value: responseData['refresh_token'],
      );
      if (responseData['user'] != null) {
        await _storage.write(
          key: 'user',
          value: jsonEncode(responseData['user']),
        );
      }
      return true;
    }
    return false;
  }

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode == 401 && includeAuth) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryHeaders = await _getHeaders(includeAuth: true);
        return await http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: retryHeaders,
        );
      }
    }
    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode == 401 && includeAuth) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryHeaders = await _getHeaders(includeAuth: true);
        return await http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: retryHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }
    return response;
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode == 401 && includeAuth) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryHeaders = await _getHeaders(includeAuth: true);
        return await http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: retryHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }
    return response;
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final request = http.Request('PATCH', Uri.parse('$baseUrl$endpoint'));
    request.headers.addAll(headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 401 && includeAuth) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryHeaders = await _getHeaders(includeAuth: true);
        final retryRequest =
            http.Request('PATCH', Uri.parse('$baseUrl$endpoint'));
        retryRequest.headers.addAll(retryHeaders);
        if (body != null) {
          retryRequest.body = jsonEncode(body);
        }
        final retryStreamed = await retryRequest.send();
        return await http.Response.fromStream(retryStreamed);
      }
    }
    return response;
  }

  Future<http.Response> delete(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode == 401 && includeAuth) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final retryHeaders = await _getHeaders(includeAuth: true);
        return await http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: retryHeaders,
        );
      }
    }
    return response;
  }
}
