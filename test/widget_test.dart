import 'package:flutter_test/flutter_test.dart';
import 'package:y_calc/models/calculator_model.dart';
import 'package:y_calc/models/extra_tools_model.dart';
import 'package:y_calc/utils/app_localizations.dart';

void main() {
  group('Advanced Calculator Engine Tests', () {
    test('Murakkab algebraik ifoda (math_expressions)', () {
      final calc = CalculatorModel();
      calc.inputDigit('1');
      calc.inputDigit('0');
      calc.inputOperator('+');
      calc.inputDigit('5');
      calc.inputOperator('×');
      calc.inputDigit('2');
      calc.calculate();
      // 10 + 5 * 2 = 20 bo'lishi kerak (amallar ketma-ketligi to'g'ri)
      expect(calc.display, '20');
    });

    test('Qavslar bilan hisoblash', () {
      final calc = CalculatorModel();
      calc.inputParenthesis('(');
      calc.inputDigit('1');
      calc.inputDigit('0');
      calc.inputOperator('+');
      calc.inputDigit('5');
      calc.inputParenthesis(')');
      calc.inputOperator('×');
      calc.inputDigit('2');
      calc.calculate();
      // (10 + 5) * 2 = 30 bo'lishi kerak
      expect(calc.display, '30');
    });
  });

  group('Localization Tests', () {
    test('Tillarni almashtirish (UZ, RU, EN)', () {
      AppStrings.currentLang = AppLanguage.uz;
      expect(AppStrings.tr('calculator'), 'Kalkulyator');

      AppStrings.currentLang = AppLanguage.ru;
      expect(AppStrings.tr('calculator'), 'Калькулятор');

      AppStrings.currentLang = AppLanguage.en;
      expect(AppStrings.tr('calculator'), 'Calculator');
    });
  });
}
