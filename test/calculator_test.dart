import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/calculator.dart';

void main() {
  group('Calulator', (){
    test('should return 5 when adding 2 and 3', (){
      final calculator = Calculator();
      expect(calculator.add(2, 3), 5);
    });

    test('should return 0 when adding 0 and 0', () {
      final calculator = Calculator();
      expect(calculator.add(0, 0), 0);
    });
  });
}