import 'package:equatable/equatable.dart';

import '../../domain/entities/number_trivia.dart';

// TODO- 这里继承好么？
class NumberTriviaModel extends Equatable {
  final String text;
  final int number;
  const NumberTriviaModel({required this.number, required this.text});

  static fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }

  @override
  List<Object?> get props => [text, number];
}
