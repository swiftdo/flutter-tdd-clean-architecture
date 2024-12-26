import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

// 相互转换
class NumberTriviaMapper {
  NumberTrivia toEntity(NumberTriviaModel model) {
    return NumberTrivia(text: model.text, number: model.number);
  }

  NumberTriviaModel toModel(NumberTrivia entity) {
    return NumberTriviaModel(text: entity.text, number: entity.number);
  }
}
