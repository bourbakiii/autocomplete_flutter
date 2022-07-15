import 'dart:convert';

import 'package:http/http.dart';

class AutocompleteApi {
  AutocompleteApi({final Client? client}) : _client = client ?? Client();

  final Client _client;
  static const _baseUrl = 'predictor.yandex.net';
  static const _apiUrl = '/api/v1/predict.json/complete';

  Future<Map> get({
    required final String query,
    required final String lang,
    final String? limit = '10',
  }) async {
    final queryParameters = {
      'key':
          'pdct.1.1.20220707T165201Z.93b18be046615aee.f5f39e2f9a7e2a3ccdb23159b374a40e132dd438',
      'q': query,
      'lang': lang,
      'limit': limit,
    };
    final request = Uri.https(_baseUrl, _apiUrl, queryParameters);

    final response = await _client.get(request);
    final result = jsonDecode(response.body) as Map;

    return result;
  }
}
