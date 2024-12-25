import '../../domain/entities/number_trivia.dart';

// TODO- 这里继承好么？
class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.number, required super.text});

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
}
