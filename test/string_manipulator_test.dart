import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/string_manipulator.dart';

void main() {
  final stringManipulator = StringManipulator();

  test('反转“Hello”时应返回“olleH”', () {
    expect(stringManipulator.reverse('Hello'), 'olleH');
  });

  test('将“hello”转换为大写时应返回“HELLO”', () {
    expect(stringManipulator.toUpperCase('hello'), 'HELLO');
  });

  test('对于“madam”作为回文应该返回 true', () {
    expect(stringManipulator.isPalindrome('madam'), true);
  });

  test('对于“hello”应该返回 false，因为它不是回文', () {
    expect(stringManipulator.isPalindrome('hello'), false);
  });
}