class CalculatorModel {
  String _expression = '';
  String _display = '0';
  String _history = '';
  bool _hasResult = false;
  bool _hasError = false;

  String get display => _display;
  String get history => _history;
  bool get hasError => _hasError;

  void inputDigit(String digit) {
    if (_hasResult) {
      if (_isOperator(digit)) {
        _expression = _display + digit;
        _history = _display + digit;
        _display = _display;
      } else {
        _expression = digit;
        _display = digit;
        _history = '';
      }
      _hasResult = false;
      _hasError = false;
      return;
    }

    if (_display == '0' && digit != '.') {
      _display = digit;
      _expression = digit;
    } else if (digit == '.' && _display.contains('.')) {
      return;
    } else if (digit == '.' && _getLastNumber().contains('.')) {
      return;
    } else {
      if (_display.length >= 16) return;
      _display = _display + digit;
      _expression = _expression + digit;
    }
    _hasError = false;
  }

  String _getLastNumber() {
    final parts = _expression.split(RegExp(r'[+\-×÷]'));
    return parts.isNotEmpty ? parts.last : '';
  }

  void inputOperator(String op) {
    _hasError = false;
    _hasResult = false;

    if (_expression.isEmpty) {
      _expression = _display + op;
      _history = _display + op;
      return;
    }

    // Replace last operator if expression ends with one
    if (_expression.isNotEmpty && _isOperator(_expression[_expression.length - 1])) {
      _expression = _expression.substring(0, _expression.length - 1) + op;
      _history = _expression;
      return;
    }

    _expression = _expression + op;
    _history = _expression;
    _display = _expression;
  }

  bool _isOperator(String s) {
    return ['+', '-', '×', '÷', '*', '/'].contains(s);
  }

  void clear() {
    _expression = '';
    _display = '0';
    _history = '';
    _hasResult = false;
    _hasError = false;
  }

  void clearEntry() {
    if (_hasResult) {
      clear();
      return;
    }
    if (_display.length <= 1) {
      _display = '0';
    } else {
      _display = _display.substring(0, _display.length - 1);
    }
    if (_expression.isNotEmpty && !_isOperator(_expression[_expression.length - 1])) {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) _expression = '0';
    }
    _hasError = false;
  }

  void toggleSign() {
    if (_display == '0' || _hasError) return;
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-' + _display;
    }
    _hasError = false;
  }

  void percentage() {
    if (_hasError) return;
    try {
      double val = double.parse(_display);
      val = val / 100;
      _display = _formatNumber(val);
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _display = 'Error';
    }
  }

  CalculationResult calculate() {
    if (_expression.isEmpty || _hasError) {
      return CalculationResult(display: _display, history: _history, hasError: _hasError);
    }

    try {
      String expr = _expression;
      // Replace display operators with actual operators
      expr = expr.replaceAll('×', '*');
      expr = expr.replaceAll('÷', '/');

      // Remove trailing operators
      while (expr.isNotEmpty && _isOperator(expr[expr.length - 1])) {
        expr = expr.substring(0, expr.length - 1);
      }

      if (expr.isEmpty) {
        return CalculationResult(display: _display, history: _history, hasError: false);
      }

      // Check division by zero
      if (RegExp(r'/\s*0(?![.\d])').hasMatch(expr)) {
        _hasError = true;
        _display = 'Cannot ÷ 0';
        _history = '';
        return CalculationResult(display: _display, history: _history, hasError: true);
      }

      double result = _evaluate(expr);

      if (result.isNaN || result.isInfinite) {
        _hasError = true;
        _display = 'Error';
        _history = '';
        return CalculationResult(display: _display, history: _history, hasError: true);
      }

      _history = _expression + '=';
      _expression = '';
      _display = _formatNumber(result);
      _hasResult = true;
      _hasError = false;

      return CalculationResult(display: _display, history: _history, hasError: false);
    } catch (e) {
      _hasError = true;
      _display = 'Error';
      _history = '';
      return CalculationResult(display: _display, history: _history, hasError: true);
    }
  }

  double _evaluate(String expr) {
    // Simple recursive-descent parser
    expr = expr.trim();
    return _parseExpression(expr, [0]);
  }

  double _parseExpression(String expr, List<int> pos) {
    double result = _parseTerm(expr, pos);
    while (pos[0] < expr.length) {
      if (expr[pos[0]] == '+') {
        pos[0]++;
        result += _parseTerm(expr, pos);
      } else if (expr[pos[0]] == '-') {
        pos[0]++;
        result -= _parseTerm(expr, pos);
      } else {
        break;
      }
    }
    return result;
  }

  double _parseTerm(String expr, List<int> pos) {
    double result = _parseFactor(expr, pos);
    while (pos[0] < expr.length) {
      if (expr[pos[0]] == '*') {
        pos[0]++;
        result *= _parseFactor(expr, pos);
      } else if (expr[pos[0]] == '/') {
        pos[0]++;
        double divisor = _parseFactor(expr, pos);
        if (divisor == 0) throw Exception('Division by zero');
        result /= divisor;
      } else {
        break;
      }
    }
    return result;
  }

  double _parseFactor(String expr, List<int> pos) {
    bool negative = false;
    if (pos[0] < expr.length && expr[pos[0]] == '-') {
      negative = true;
      pos[0]++;
    } else if (pos[0] < expr.length && expr[pos[0]] == '+') {
      pos[0]++;
    }

    if (pos[0] < expr.length && expr[pos[0]] == '(') {
      pos[0]++;
      double result = _parseExpression(expr, pos);
      if (pos[0] < expr.length && expr[pos[0]] == ')') pos[0]++;
      return negative ? -result : result;
    }

    int start = pos[0];
    while (pos[0] < expr.length &&
        (RegExp(r'[0-9.]').hasMatch(expr[pos[0]]))) {
      pos[0]++;
    }
    if (start == pos[0]) throw Exception('Invalid expression');
    double val = double.parse(expr.substring(start, pos[0]));
    return negative ? -val : val;
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      // Integer
      String s = value.toInt().toString();
      return s;
    } else {
      // Decimal - remove trailing zeros
      String s = value.toStringAsFixed(10);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      if (s.length > 16) {
        s = value.toStringAsExponential(6);
      }
      return s;
    }
  }
}

class CalculationResult {
  final String display;
  final String history;
  final bool hasError;

  CalculationResult({
    required this.display,
    required this.history,
    required this.hasError,
  });
}
