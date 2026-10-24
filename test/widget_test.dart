import 'package:flutter_test/flutter_test.dart';
import 'package:y_calc/models/calculator_model.dart';

void main() {
  group('CalculatorModel Tests', () {
    late CalculatorModel calc;

    setUp(() {
      calc = CalculatorModel();
    });

    test('Initial state shows 0', () {
      expect(calc.display, '0');
    });

    test('Input digit changes display', () {
      calc.inputDigit('5');
      expect(calc.display, '5');
    });

    test('Addition works correctly', () {
      calc.inputDigit('5');
      calc.inputOperator('+');
      calc.inputDigit('3');
      final result = calc.calculate();
      expect(result.display, '8');
    });

    test('Subtraction works correctly', () {
      calc.inputDigit('9');
      calc.inputOperator('-');
      calc.inputDigit('4');
      final result = calc.calculate();
      expect(result.display, '5');
    });

    test('Multiplication works correctly', () {
      calc.inputDigit('6');
      calc.inputOperator('×');
      calc.inputDigit('7');
      final result = calc.calculate();
      expect(result.display, '42');
    });

    test('Division works correctly', () {
      calc.inputDigit('1');
      calc.inputDigit('0');
      calc.inputOperator('÷');
      calc.inputDigit('2');
      final result = calc.calculate();
      expect(result.display, '5');
    });

    test('Division by zero shows error', () {
      calc.inputDigit('5');
      calc.inputOperator('÷');
      calc.inputDigit('0');
      final result = calc.calculate();
      expect(result.hasError, true);
    });

    test('Clear resets to 0', () {
      calc.inputDigit('5');
      calc.inputDigit('5');
      calc.clear();
      expect(calc.display, '0');
    });

    test('Percentage converts correctly', () {
      calc.inputDigit('5');
      calc.inputDigit('0');
      calc.percentage();
      expect(calc.display, '0.5');
    });

    test('Toggle sign works', () {
      calc.inputDigit('5');
      calc.toggleSign();
      expect(calc.display, '-5');
    });

    test('Decimal point input works', () {
      calc.inputDigit('3');
      calc.inputDigit('.');
      calc.inputDigit('1');
      calc.inputDigit('4');
      expect(calc.display, '3.14');
    });

    test('Cannot enter two decimal points', () {
      calc.inputDigit('3');
      calc.inputDigit('.');
      calc.inputDigit('1');
      calc.inputDigit('.');
      calc.inputDigit('4');
      expect(calc.display, '3.14');
    });
  });
}
