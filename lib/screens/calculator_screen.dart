import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '../widgets/calc_button.dart';
import '../widgets/display_panel.dart';
import '../themes/app_theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorModel _calc = CalculatorModel();
  String _display = '0';
  String _history = '';
  bool _hasError = false;

  void _onButton(String label) {
    setState(() {
      switch (label) {
        case 'AC':
          _calc.clear();
          _display = '0';
          _history = '';
          _hasError = false;
          break;
        case '⌫':
          _calc.clearEntry();
          _display = _calc.display;
          _hasError = _calc.hasError;
          break;
        case '+/-':
          _calc.toggleSign();
          _display = _calc.display;
          break;
        case '%':
          _calc.percentage();
          _display = _calc.display;
          _hasError = _calc.hasError;
          break;
        case '=':
          final result = _calc.calculate();
          _display = result.display;
          _history = result.history;
          _hasError = result.hasError;
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
          _calc.inputOperator(label);
          _display = _calc.display;
          _history = _calc.history;
          _hasError = false;
          break;
        default:
          _calc.inputDigit(label);
          _display = _calc.display;
          _history = _calc.history;
          _hasError = _calc.hasError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonAreaHeight = size.height * 0.62;
    final double buttonSize = (size.width - 5 * 14) / 4;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: DisplayPanel(
                display: _display,
                history: _history,
                hasError: _hasError,
              ),
            ),
            _buildButtonGrid(buttonAreaHeight, buttonSize),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accentPurple, AppColors.accentCyan],
            ).createShader(bounds),
            child: const Text(
              'Y CALC',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentPurple.withOpacity(0.4),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.accentPurple.withOpacity(0.1),
                  AppColors.accentCyan.withOpacity(0.1),
                ],
              ),
            ),
            child: const Text(
              'DARK MODE',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.accentCyan,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid(double buttonAreaHeight, double buttonSize) {
    const gap = 14.0;

    final List<List<Map<String, dynamic>>> rows = [
      [
        {'label': 'AC', 'type': ButtonType.clear},
        {'label': '+/-', 'type': ButtonType.special},
        {'label': '%', 'type': ButtonType.special},
        {'label': '÷', 'type': ButtonType.operator},
      ],
      [
        {'label': '7', 'type': ButtonType.number},
        {'label': '8', 'type': ButtonType.number},
        {'label': '9', 'type': ButtonType.number},
        {'label': '×', 'type': ButtonType.operator},
      ],
      [
        {'label': '4', 'type': ButtonType.number},
        {'label': '5', 'type': ButtonType.number},
        {'label': '6', 'type': ButtonType.number},
        {'label': '-', 'type': ButtonType.operator},
      ],
      [
        {'label': '1', 'type': ButtonType.number},
        {'label': '2', 'type': ButtonType.number},
        {'label': '3', 'type': ButtonType.number},
        {'label': '+', 'type': ButtonType.operator},
      ],
      [
        {'label': '⌫', 'type': ButtonType.special},
        {'label': '0', 'type': ButtonType.number},
        {'label': '.', 'type': ButtonType.number},
        {'label': '=', 'type': ButtonType.equal},
      ],
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      height: buttonAreaHeight,
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              children: rows.map((row) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: row.asMap().entries.map((entry) {
                        final item = entry.value;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: entry.key < row.length - 1 ? gap : 0,
                            ),
                            child: CalcButton(
                              label: item['label'] as String,
                              type: item['type'] as ButtonType,
                              onPressed: () => _onButton(item['label'] as String),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
