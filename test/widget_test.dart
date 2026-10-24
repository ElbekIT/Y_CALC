import 'package:flutter_test/flutter_test.dart';
import 'package:y_calc/models/calculator_model.dart';
import 'package:y_calc/models/converter_model.dart';
import 'package:y_calc/models/finance_model.dart';
import 'package:y_calc/models/programmer_model.dart';
import 'package:y_calc/models/extra_tools_model.dart';

void main() {
  group('Calculator Tests', () {
    test('Oddiy hisob-kitob', () {
      final calc = CalculatorModel();
      calc.inputDigit('1');
      calc.inputDigit('5');
      calc.inputOperator('+');
      calc.inputDigit('2');
      calc.inputDigit('5');
      calc.calculate();
      expect(calc.display, '40');
    });
  });

  group('Extra Tools Tests', () {
    test('Bozor narxi hisoblash (350 gr)', () {
      final price = MarketItemCalc.calcWeightPrice(pricePerKg: 100000, grams: 350);
      expect(price, 35000);
    });

    test('Yoqilg\'i xarajati hisoblash', () {
      final cost = FuelCalc.calcTripCost(distanceKm: 100, consumptionPer100Km: 10, fuelPrice: 12000);
      expect(cost, 120000);
    });

    test('Raqamni o\'zbekcha so\'zga aylantirish', () {
      final words = NumberToWordsUz.convert(1500000);
      expect(words, 'bir million besh yuz ming');
    });
  });
}
