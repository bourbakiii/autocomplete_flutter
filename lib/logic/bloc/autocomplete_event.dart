part of 'autocomplete_bloc.dart';

abstract class AutocompleteEvent extends Equatable {
  const AutocompleteEvent();

  @override
  List<Object> get props => [];
}

/// Создание события для вызова _get запроса в state manager
class AutocompleteGetEvent extends AutocompleteEvent {
  const AutocompleteGetEvent(this.query);
  final String query;

  @override
  List<Object> get props => [
        query,
      ];
}

/// Создание события для вызова _select запроса в state manager
class AutocompleteSelectEvent extends AutocompleteEvent {
  const AutocompleteSelectEvent(this.query);
  final String query;

  @override
  List<Object> get props => [
        query,
      ];
}
