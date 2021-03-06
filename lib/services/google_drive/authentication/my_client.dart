//version 1.0.0+1

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyClient extends http.BaseClient {
  final Map<String, String> defaultHeaders;
  final http.Client _httpClient = http.Client();

  MyClient({this.defaultHeaders = const {}});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }

  @override
  Future<http.Response> get(url, {Map<String, String>? headers}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.get(url, headers: headers);
  }

  @override
  Future<http.Response> post(url,
      {Object? body, Encoding? encoding, Map<String, String>? headers}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.post(url, headers: headers, encoding: encoding);
  }

  @override
  Future<http.Response> patch(url,
      {Map<String, String>? headers, body, Encoding? encoding}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.patch(url, headers: headers, encoding: encoding);
  }

  @override
  Future<http.Response> put(url,
      {Map<String, String>? headers, body, Encoding? encoding}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.put(url,
        headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> head(url, {Map<String, String>? headers}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.head(url, headers: headers);
  }

  @override
  Future<http.Response> delete(url,
      {Object? body, Encoding? encoding, Map<String, String>? headers}) {
    headers?.addAll(defaultHeaders);
    return _httpClient.delete(url, headers: headers);
  }
}
