import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client_tools/client_tools.dart';
import 'package:http/http.dart';
import 'package:tools/tools.dart';

class SessionExpiredFailure implements Exception {}

class NetworkFailure implements Exception {}

class ServerFailure implements Exception {}

// TODO: how to make file Map<String, file>

class HwdbHttpClient {
  // THIS HELPS CACHE DATA LOCALLY
  final SharedPreferences _localCache;

  // DETERMINES WHETHER WE USE HTTPS (INSTEAD OF HTTP)
  final bool _useHttps;

  // LOCATES API
  final String _apiUrl;

  // DETERMINES WHETHER THE CLIENT WILL PRINT RESPONSES
  final bool _debug;

  // CLIENT CACHES THE TOKEN WITH THIS KEY
  static const localTokenKey = 'token';

  // SERVER SENDS THE TOKEN WITH THIS KEY
  static const remoteTokenKey = 'token';

  HwdbHttpClient({
    required SharedPreferences localCache,
    String apiUrl = '62.234.5.130:8080',
    bool useHttps = false,
    bool debug = false,
  })  : _debug = debug, _apiUrl = apiUrl,
        _localCache = localCache,
        _useHttps = useHttps;

  Future<Json> get(String query, [Json? qargs]) async {
    return _sendSimpleRequest('GET', query, qargs);
  }

  Future<Json> post(String query, {Json? qargs, Json? args, List<File>? files}) async {
    final res = await _sendMultipartRequest('POST', query, qargs, args, files);
    await _cachePotentialToken(res);
    _checkLogOut(res);
    return res;
  }

  Future<Json> put(String query, {Json? qargs, Json? args, List<File>? files}) async {
    return _sendMultipartRequest('PUT', query, qargs, args, files);
  }

  Future<Json> patch(String query, {Json? qargs, Json? args, List<File>? files}) async {
    return _sendMultipartRequest('PATCH', query, qargs, args, files);
  }

  Future<Json> delete(String query, [Json? qargs]) async {
    return _sendSimpleRequest('DELETE', query, qargs);
  }

  /// Send a request that only contains a request string
  Future<Json> _sendSimpleRequest(String method, String query, [Json? qargs]) async {
    // MAKE THE BASE REQUEST
    final strQargs = _toStringMap(qargs);
    final uri = _useHttps ? Uri.https(_apiUrl, query, strQargs) : Uri.http(_apiUrl, query, strQargs);
    final request = Request(method, uri);

    // FILL IN THE AUTHORIZATION HEADER
    final token = _localCache.getString(localTokenKey);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // SEND THE REQUEST AND RETURN THE RESPONSE
    try {
      final streamedResponse = await request.send();
      final response = _decodeResponse(await Response.fromStream(streamedResponse));
      _logResponseIfDebug(query, response);
      return response;
    }

    // IF NETWORK FAILED
    on SocketException {
      throw NetworkFailure();
    }

    // IF NETWORK FAILED
    on ClientException {
      throw NetworkFailure();
    }
  }

  /// Sends a request that could contain query parameters, a body, and files.
  Future<Json> _sendMultipartRequest(String method, String query, Json? qargs, Json? args, List<File>? files) async {
    // MAKE THE BASE REQUEST
    final strQargs = _toStringMap(qargs);
    final uri = _useHttps ? Uri.https(_apiUrl, query, strQargs) : Uri.http(_apiUrl, query, strQargs);
    final request = MultipartRequest(method, uri);

    // FILL IN THE AUTHORIZATION HEADER
    final token = _localCache.getString(localTokenKey);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // COVERT ALL ARGUMENTS TO STRING AND ADD THEM TO THE REQUEST
    if (args != null) {
      request.fields.addAll(_toStringMap(args)!);
    }

    // READ ALL FILES AND ADD THEM TO THE REQUEST
    if (files != null) {
      for (final file in files) {
        final fileName = file.uri.pathSegments.last;
        final fileBytes = await file.readAsBytes();
        request.files.add(MultipartFile.fromBytes(fileName, fileBytes, filename: fileName));
      }
    }

    // SEND THE REQUEST AND RETURN THE RESPONSE
    try {
      final streamedResponse = await request.send();
      final response = _decodeResponse(await Response.fromStream(streamedResponse));
      _logResponseIfDebug(query, response);
      return response;
    }

    // IF THE NETWORK FAILED
    on SocketException {
      throw NetworkFailure();
    }
  }

  /// Converts a response to json.
  Json _decodeResponse(Response response) {
    try {
      final json = jsonDecode(response.body) as Json;

      _handleErrors(json);

      return json;
    } on FormatException {
      return switch (response.body) {
        'Internal Server Error' => {'error': Errors.unknown.toJson()},
        'Not Found' => {'error': Errors.notFound.toJson()},
        'Route not found' => throw ServerFailure(),
        _ => {'error': response.body},
      };
    }
  }

  /// Does special operations on special errors.
  void _handleErrors(Json json) {
    if (json['error'] != null) {
      if (Errors.unauthorized.matches(json['error'])) {
        throw SessionExpiredFailure();
      }
    }
  }

  /// Caches auth tokens when it's present.
  Future<void> _cachePotentialToken(Json json) async {
    if (json[remoteTokenKey] != null) {
      await _localCache.setString(localTokenKey, json[remoteTokenKey]);
    }
  }

  /// Clears the token when the user has logged out.
  Future<void> _checkLogOut(Json json) async {
    if (Events.loggedOut.matches(json['event'])) {
      await _localCache.remove(localTokenKey);
    }
  }

  // Converts every value in a json map to a string.
  Map<String, String>? _toStringMap(Json? json) {
    if (json == null) {
      return null;
    }

    final stringMap = <String, String>{};
    for (final entry in json.entries) {
      final k = entry.key;
      final v = entry.value;

      // REMOVE NULL VALUES
      if (v == null) {
        continue;
      }
      // STRING
      else if (v is String) {
        stringMap[k] = v;
      }
      // NUMBER (INT, DOUBLE)
      else if (v is num) {
        stringMap[k] = v.toString();
      }
      // ENUMS ARE NOT PERMITTED
      else if (v is Enum) {
        throw Exception('Enums should not be in query parameters not request bodies. Try using enum.name');
      }
      // LISTS
      else if (v is List) {
        stringMap[k] = jsonEncode(v);
      }
      // OTHER LISTS
      else if (v is Iterable) {
        stringMap[k] = jsonEncode(v.toList());
      }
      // OTHER TYPE
      else {
        throw Exception('Unexpected type in json that is to be converted to string map: ${v.runtimeType} $v');
      }
    }

    return stringMap;
  }

  void _logResponseIfDebug(String query, Json response) {
    if (_debug) {
      log('RESPONSE FOR $query');
      log(response.pretty());
      log('----------------------------');
    }
  }
}
