part of 'autocomplete_bloc.dart';

/// Статусы состояния приложения
enum AutocompleteStatus {
  initial,
  loading,
  success,
  failed,
  cleared,
}

/// Расширение объекта статуса приложения для проверки текущего статуса
extension AutocompleteStatusX on AutocompleteStatus {
  bool get isInitial => this == AutocompleteStatus.initial;
  bool get isLoading => this == AutocompleteStatus.loading;
  bool get isSuccess => this == AutocompleteStatus.success;
  bool get isFailed => this == AutocompleteStatus.failed;
  bool get isCleared => this == AutocompleteStatus.cleared;
}

/// Класс состояния приложения
class AutocompleteState extends Equatable {
  const AutocompleteState({
    this.status = AutocompleteStatus.initial,
    this.query = '',
    this.position = 0,
    this.endOfWord = false,
    this.suggestions = const [],
  });

  /// Статус
  final AutocompleteStatus status;

  /// Текущий запрос
  final String query;

  /// Позиция в запросе
  final int position;

  /// Bool переменная конца слова
  final bool endOfWord;

  /// Текущие подсказки
  final List<Suggestion> suggestions;

  /// Метод для изменения состояния
  AutocompleteState copyWith({
    final AutocompleteStatus? status,
    final String? query,
    final int? position,
    final bool? endOfWord,
    final List<Suggestion>? suggestions,
  }) {
    return AutocompleteState(
      status: status ?? this.status,
      query: query ?? this.query,
      position: position ?? this.position,
      endOfWord: endOfWord ?? this.endOfWord,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  /// Очищение состояния
  AutocompleteState clear() {
    return const AutocompleteState(
      status: AutocompleteStatus.cleared,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        suggestions,
      ];
}
