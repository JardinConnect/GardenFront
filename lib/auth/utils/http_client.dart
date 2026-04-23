import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
      // return 'http://100.126.179.10:8000/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://127.0.0.1:8000/api';
      // return 'http://100.126.179.10:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
    // return 'http://100.126.179.10:8000/api';
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', responseData['access_token']);
      await prefs.setString('refresh_token', responseData['refresh_token']);
      if (responseData['user'] != null) {
        await prefs.setString('user', jsonEncode(responseData['user']));
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
        final retryRequest = http.Request(
          'PATCH',
          Uri.parse('$baseUrl$endpoint'),
        );
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

  Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
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
