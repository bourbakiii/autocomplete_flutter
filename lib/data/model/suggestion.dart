import 'package:equatable/equatable.dart';

class Suggestion extends Equatable {
  const Suggestion({
    required this.text,
  });

  final String text;

  /// Нужно для сравнения
  @override
  List<Object?> get props {
    return [
      text,
    ];
  }
}
