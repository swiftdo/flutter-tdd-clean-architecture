import 'package:flutter_test/flutter_test.dart';
import 'package:feature_number_trivia/data/mapper/number_trivia_mapper.dart';
import 'package:feature_number_trivia/data/models/number_trivia_model.dart';
import 'package:feature_number_trivia/domain/entities/number_trivia.dart';

void main() {
  group('NumberTriviaMapper', () {
    test('toEntity should map model to entity correctly', () {
      // 创建一个模型实例
      const model = NumberTriviaModel(text: 'Test Text', number: 123);

      // 使用映射器将模型转换为实体
      final entity = NumberTriviaMapper().toEntity(model);

      // 验证实体的属性是否与模型匹配
      expect(entity.text, equals(model.text));
      expect(entity.number, equals(model.number));
    });

    test('toModel should map entity to model correctly', () {
      // 创建一个实体实例
      const entity = NumberTrivia(text: 'Test Text', number: 123);

      // 使用映射器将实体转换为模型
      final model = NumberTriviaMapper().toModel(entity);

      // 验证模型的属性是否与实体匹配
      expect(model.text, equals(entity.text));
      expect(model.number, equals(entity.number));
    });
  });
}
