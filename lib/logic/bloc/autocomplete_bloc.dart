import 'package:autocomplete_app/data/model/suggestion.dart';
import 'package:autocomplete_app/data/repositories/autocomplete_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'autocomplete_event.dart';
part 'autocomplete_state.dart';

/// Компонент бизнес логики (BLOC - Business LOgic Component), который наблюдает за состоянием приложения
class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  AutocompleteBloc(this._autocompleteRepo) : super(const AutocompleteState()) {
    on<AutocompleteGetEvent>(
      _get,
      transformer: restartable(),
    );
    on<AutocompleteSelectEvent>(
      _select,
    );
  }

  /// Передача класса для работы с API
  final AutocompleteRepo _autocompleteRepo;

  /// Запрос на получение подсказок с API Yandex Предиктор
  void _get(AutocompleteGetEvent event, Emitter<AutocompleteState> emit) async {
    if (event.query == '') {
      emit(state.clear());
      return;
    }
    emit(
      state.copyWith(
        status: AutocompleteStatus.loading,
        query: event.query,
      ),
    );
    try {
      final response = await _autocompleteRepo.get(
        query: event.query,
        lang: 'ru',
        limit: 100,
      );

      emit(
        state.copyWith(
          status: AutocompleteStatus.success,
          position: response.item1,
          endOfWord: response.item2,
          suggestions: response.item3,
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          status: AutocompleteStatus.failed,
        ),
      );
    }
  }

  /// Выбор подсказки и запись в state
  void _select(
    AutocompleteSelectEvent event,
    Emitter<AutocompleteState> emit,
  ) async {
    late final String newWord;
    if (state.endOfWord) {
      newWord =
          '${state.query}${state.position == 1 ? ' ' : ''}${event.query} ';
    } else {
      final arQuery = state.query.trimRight().split(' ')
        ..removeLast()
        ..add(event.query);
      newWord = '${arQuery.join(' ')} ';
    }
    emit(
      state.copyWith(
        query: newWord,
      ),
    );
    add(AutocompleteGetEvent(state.query));
  }
}
