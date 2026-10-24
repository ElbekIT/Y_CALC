import 'package:flutter_test/flutter_test.dart';
import 'package:y_calc/models/calculator_model.dart';
import 'package:y_calc/models/converter_model.dart';
import 'package:y_calc/models/finance_model.dart';
import 'package:y_calc/models/programmer_model.dart';

void main() {
  group('CalculatorModel Tests', () {
    late CalculatorModel calc;

    setUp(() {
      calc = CalculatorModel();
    });

    test('Boshlangich holat 0 ko\'rsatishi kerak', () {
      expect(calc.display, '0');
    });

    test('Raqam kiritilganda displey yangilanadi', () {
      calc.inputDigit('5');
      expect(calc.display, '5');
    });

    test('Qo\'shish amali', () {
      calc.inputDigit('5');
      calc.inputOperator('+');
      calc.inputDigit('3');
      calc.calculate();
      expect(calc.display, '8');
    });

    test('Ayirish amali', () {
      calc.inputDigit('9');
      calc.inputOperator('-');
      calc.inputDigit('4');
      calc.calculate();
      expect(calc.display, '5');
    });

    test('Ko\'paytirish amali', () {
      calc.inputDigit('6');
      calc.inputOperator('×');
      calc.inputDigit('7');
      calc.calculate();
      expect(calc.display, '42');
    });

    test('Bo\'lish amali', () {
      calc.inputDigit('1');
      calc.inputDigit('0');
      calc.inputOperator('÷');
      calc.inputDigit('2');
      calc.calculate();
      expect(calc.display, '5');
    });

    test('Nolga bo\'lish xatosi', () {
      calc.inputDigit('5');
      calc.inputOperator('÷');
      calc.inputDigit('0');
      calc.calculate();
      expect(calc.hasError, true);
    });

    test('Jonli hisoblash (Live preview)', () {
      calc.inputDigit('1');
      calc.inputDigit('2');
      calc.inputOperator('+');
      calc.inputDigit('8');
      expect(calc.livePreview, '20');
    });
  });

  group('ConverterModel Tests', () {
    test('Metrdan kilometrga o\'tkazish', () {
      final res = ConverterModel.convert(
        category: UnitCategory.length,
        value: 1000,
        from: ConverterModel.units[UnitCategory.length]![0], // m
        to: ConverterModel.units[UnitCategory.length]![1],   // km
      );
      expect(res, 1.0);
    });
  });

  group('FinanceModel Tests', () {
    test('Chegirma hisoblash', () {
      final res = FinanceModel.calculateDiscount(originalPrice: 100000, discountPercent: 20);
      expect(res.savedAmount, 20000);
      expect(res.finalPrice, 80000);
    });
  });

  group('ProgrammerModel Tests', () {
    test('O\'nlikdan o\'n oltilikka (DEC to HEX)', () {
      final prog = ProgrammerModel();
      prog.inputDec("255");
      expect(prog.hex, 'FF');
      expect(prog.bin, '1111 1111');
    });
  });
}
