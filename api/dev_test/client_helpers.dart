import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:tools/tools.dart';

class SessionExpiredFailure implements Exception {}

// TODO: how to make file Map<String, file>

class HttpClient {
  final Json _localCache;
  final bool _useHttps;
  final String _apiUrl;

  static const localTokenKey = 'token';
  static const remoteTokenKey = 'token';

  HttpClient({
    String apiUrl = '62.234.5.130:8080',
    bool useHttps = false,
  })  : _apiUrl = apiUrl,
        _localCache = {},
        _useHttps = useHttps;

  Future<Json> get(String query, [Json? qargs]) async {
    return _sendSimpleRequest('GET', query, qargs);
  }

  Future<Json> post(String query, {Json? qargs, Json? args, List<File>? files}) async {
    final json = await _sendMultipartRequest('POST', query, qargs, args, files);
    await _cacheToken(json);
    _checkLogOut(json);
    return json;
  }

  Future<Json> put(String query, {Json? qargs, Json? args, List<File>? files}) async {
    return _sendMultipartRequest('PUT', query, qargs, args, files);
  }

  Future<Json> patch(String query, {Json? qargs, Json? args, List<File>? files}) async {
    return _sendMultipartRequest('PATCH', query, qargs, args, files);
  }

  Future<Json> delete(String query, {Json? qargs, Json? args}) async {
    return _sendSimpleRequest('DELETE', query, qargs, args);
  }

  Future<Json> _sendSimpleRequest(String method, String query, [Json? qargs, Json? args]) async {
    // construct request
    final uri = _useHttps ? Uri.https(_apiUrl, query, qargs) : Uri.http(_apiUrl, query, qargs);
    final request = Request(method, uri);

    // fill auth header
    final token = _localCache[localTokenKey];
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // fill body in request
    if (args != null) {
      request.body = jsonEncode({
        for (final bodyEntry in args.entries)
          if (bodyEntry.value is Enum) bodyEntry.key: bodyEntry.value.name else bodyEntry.key: bodyEntry.value,
      });
    }

    // send request and decode response
    final streamedResponse = await request.send();
    final response = await Response.fromStream(streamedResponse);
    try {
      final json = jsonDecode(response.body) as Json;

      _checkErrors(json);

      return json;
    } on FormatException {
      return {'error': response.body};
    }
  }

  Future<Json> _sendMultipartRequest(String method, String query, Json? qargs, Json? args, List<File>? files) async {
    // construct request
    final uri = _useHttps ? Uri.https(_apiUrl, query, qargs) : Uri.http(_apiUrl, query, qargs);
    final request = MultipartRequest(method, uri);

    // fill auth header
    final token = _localCache[localTokenKey];
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // fill body in request
    if (args != null) {
      for (final bodyEntry in args.entries) {
        if (bodyEntry.value is Enum) {
          request.fields[bodyEntry.key] = bodyEntry.value.name;
        } else if (bodyEntry.value != null) {
          request.fields[bodyEntry.key] = bodyEntry.value;
        }
      }
    }

    // fill files in request
    if (files != null) {
      for (final file in files) {
        final fileName = file.uri.pathSegments.last;
        final fileBytes = await file.readAsBytes();
        request.files.add(MultipartFile.fromBytes(fileName, fileBytes, filename: fileName));
      }
    }

    // send request and decode response
    final streamedResponse = await request.send();
    final response = await Response.fromStream(streamedResponse);
    try {
      final json = jsonDecode(response.body) as Json;

      _checkErrors(json);

      return json;
    } on FormatException {
      return {'error': response.body};
    }
  }

  void _checkErrors(Json json) {
    if (json['error'] != null) {
      if (json['error'] == Errors.unauthorized.name) {
        throw SessionExpiredFailure();
      }
    }
  }

  Future<void> _cacheToken(Json json) async {
    if (json[remoteTokenKey] != null) {
      _localCache[localTokenKey] = json[remoteTokenKey];
    }
  }

  Future<void> _checkLogOut(Json json) async {
    if (json['event'] == Events.loggedOut.name) {
      await _localCache.remove(localTokenKey);
    }
  }
}
