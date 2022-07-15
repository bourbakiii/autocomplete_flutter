import 'package:autocomplete_app/data/model/suggestion.dart';
import 'package:autocomplete_app/data/providers/autocompete_api.dart';
import 'package:tuple/tuple.dart';

class AutocompleteRepo {
  AutocompleteRepo(this._api);

  final AutocompleteApi _api;

  Future<Tuple3<int, bool, List<Suggestion>>> get({
    required final String query,
    required final String lang,
    final int? limit,
  }) async {
    final response = await _api.get(
      query: query,
      lang: lang,
      limit: limit.toString(),
    );
    return Tuple3(
      response['pos'],
      response['endOfWord'],
      (response['text'] as List).map((e) => Suggestion(text: e)).toList(),
    );
  }
}
