import 'dart:math' as math;

class HistoryItem {
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.expression,
    required this.result,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class CalculatorModel {
  String _expression = '';
  String _display = '0';
  String _livePreview = '';
  String _lastFullExpression = '';
  bool _hasResult = false;
  bool _hasError = false;
  bool _isRadians = false;
  double _memory = 0.0;

  final List<HistoryItem> _history = [];

  // Getters
  String get display => _display;
  String get expression => _expression;
  String get livePreview => _livePreview;
  String get lastFullExpression => _lastFullExpression;
  bool get hasError => _hasError;
  bool get isRadians => _isRadians;
  double get memory => _memory;
  List<HistoryItem> get history => List.unmodifiable(_history);

  void toggleRadDeg() {
    _isRadians = !_isRadians;
    _updateLivePreview();
  }

  void memoryClear() {
    _memory = 0.0;
  }

  void memoryStore() {
    final val = double.tryParse(_display.replaceAll(',', ''));
    if (val != null) _memory = val;
  }

  void memoryRecall() {
    inputDigit(_formatNumber(_memory));
  }

  void memoryAdd() {
    final val = double.tryParse(_display.replaceAll(',', ''));
    if (val != null) _memory += val;
  }

  void memorySubtract() {
    final val = double.tryParse(_display.replaceAll(',', ''));
    if (val != null) _memory -= val;
  }

  void inputDigit(String val) {
    if (_hasResult) {
      if (_isOperator(val)) {
        _expression = _display + val;
      } else {
        _expression = val;
        _display = val;
      }
      _hasResult = false;
      _hasError = false;
      _updateLivePreview();
      return;
    }

    if (_display == '0' && val != '.') {
      _display = val;
      _expression = val;
    } else if (val == '.') {
      if (_getLastToken().contains('.')) return;
      _display += '.';
      _expression += '.';
    } else {
      _display += val;
      _expression += val;
    }

    _hasError = false;
    _updateLivePreview();
  }

  void inputOperator(String op) {
    _hasError = false;
    _hasResult = false;

    if (_expression.isEmpty) {
      _expression = _display + op;
    } else if (_isOperator(_expression[_expression.length - 1])) {
      // Oxirgi operatorni almashtirish
      _expression = _expression.substring(0, _expression.length - 1) + op;
    } else {
      _expression += op;
    }
    _display = _expression;
    _updateLivePreview();
  }

  void inputFunction(String fn) {
    _hasError = false;
    _hasResult = false;
    if (_hasResult || _display == '0') {
      _expression = '$fn(';
      _display = '$fn(';
    } else {
      _expression += '$fn(';
      _display = _expression;
    }
    _updateLivePreview();
  }

  void inputParenthesis(String paren) {
    if (_hasResult) {
      _expression = paren;
      _display = paren;
      _hasResult = false;
    } else {
      _expression += paren;
      _display = _expression;
    }
    _updateLivePreview();
  }

  void inputConstant(String c) {
    String val = c == 'π' ? math.pi.toStringAsFixed(8) : math.e.toStringAsFixed(8);
    inputDigit(val);
  }

  void backspace() {
    if (_hasResult) {
      clear();
      return;
    }
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression.isEmpty ? '0' : _expression;
    } else {
      _display = '0';
    }
    _hasError = false;
    _updateLivePreview();
  }

  void clear() {
    _expression = '';
    _display = '0';
    _livePreview = '';
    _hasResult = false;
    _hasError = false;
  }

  void clearHistory() {
    _history.clear();
  }

  void toggleSign() {
    if (_display == '0' || _hasError) return;
    try {
      final double val = double.parse(_display.replaceAll(',', ''));
      _display = _formatNumber(-val);
      _expression = _display;
      _updateLivePreview();
    } catch (_) {}
  }

  void percentage() {
    if (_hasError) return;
    try {
      final double val = double.parse(_display.replaceAll(',', ''));
      final double res = val / 100.0;
      _display = _formatNumber(res);
      _expression = _display;
      _updateLivePreview();
    } catch (_) {
      _hasError = true;
      _display = 'Xato';
    }
  }

  void calculate() {
    if (_expression.isEmpty || _hasError) return;

    try {
      final double res = _evaluateExpression(_expression);
      if (res.isNaN || res.isInfinite) {
        _hasError = true;
        _display = res.isInfinite ? "0 ga bo'lib bo'lmaydi" : "Xato";
        _livePreview = '';
        return;
      }

      final String formatted = _formatNumber(res);
      _history.insert(0, HistoryItem(
        expression: _expression,
        result: formatted,
      ));
      if (_history.length > 50) _history.removeLast();

      _lastFullExpression = '$_expression =';
      _display = formatted;
      _expression = formatted;
      _livePreview = '';
      _hasResult = true;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _display = "Xato";
      _livePreview = '';
    }
  }

  void _updateLivePreview() {
    if (_expression.isEmpty || !_hasAnyOperator(_expression)) {
      _livePreview = '';
      return;
    }

    try {
      // Yopilmagan qavslarni vaqtincha yopib sinash
      String testExpr = _expression;
      int openParen = '('.allMatches(testExpr).length;
      int closeParen = ')'.allMatches(testExpr).length;
      if (openParen > closeParen) {
        testExpr += ')' * (openParen - closeParen);
      }

      if (_isOperator(testExpr[testExpr.length - 1])) {
        testExpr = testExpr.substring(0, testExpr.length - 1);
      }

      final double res = _evaluateExpression(testExpr);
      if (!res.isNaN && !res.isInfinite) {
        _livePreview = _formatNumber(res);
      } else {
        _livePreview = '';
      }
    } catch (_) {
      _livePreview = '';
    }
  }

  bool _hasAnyOperator(String s) {
    return s.contains('+') || s.contains('-') || s.contains('×') || 
           s.contains('÷') || s.contains('^') || s.contains('%') ||
           s.contains('sin') || s.contains('cos') || s.contains('tan') ||
           s.contains('√') || s.contains('ln') || s.contains('log');
  }

  bool _isOperator(String c) {
    return ['+', '-', '×', '÷', '*', '/', '^', '%'].contains(c);
  }

  String _getLastToken() {
    final parts = _expression.split(RegExp(r'[+\-×÷*\/^()]'));
    return parts.isNotEmpty ? parts.last : '';
  }

  double _evaluateExpression(String expr) {
    String clean = expr.replaceAll('×', '*').replaceAll('÷', '/');
    return _parseAddSub(clean, [0]);
  }

  double _parseAddSub(String s, List<int> pos) {
    double left = _parseMulDiv(s, pos);
    while (pos[0] < s.length) {
      _skipSpaces(s, pos);
      if (pos[0] >= s.length) break;
      final char = s[pos[0]];
      if (char == '+') {
        pos[0]++;
        left += _parseMulDiv(s, pos);
      } else if (char == '-') {
        pos[0]++;
        left -= _parseMulDiv(s, pos);
      } else {
        break;
      }
    }
    return left;
  }

  double _parseMulDiv(String s, List<int> pos) {
    double left = _parsePower(s, pos);
    while (pos[0] < s.length) {
      _skipSpaces(s, pos);
      if (pos[0] >= s.length) break;
      final char = s[pos[0]];
      if (char == '*') {
        pos[0]++;
        left *= _parsePower(s, pos);
      } else if (char == '/') {
        pos[0]++;
        double denom = _parsePower(s, pos);
        if (denom == 0) throw Exception("Division by zero");
        left /= denom;
      } else {
        break;
      }
    }
    return left;
  }

  double _parsePower(String s, List<int> pos) {
    double base = _parseUnary(s, pos);
    while (pos[0] < s.length) {
      _skipSpaces(s, pos);
      if (pos[0] >= s.length) break;
      if (s[pos[0]] == '^') {
        pos[0]++;
        double exp = _parseUnary(s, pos);
        base = math.pow(base, exp).toDouble();
      } else {
        break;
      }
    }
    return base;
  }

  double _parseUnary(String s, List<int> pos) {
    _skipSpaces(s, pos);
    if (pos[0] >= s.length) return 0.0;

    if (s[pos[0]] == '+') {
      pos[0]++;
      return _parseUnary(s, pos);
    }
    if (s[pos[0]] == '-') {
      pos[0]++;
      return -_parseUnary(s, pos);
    }

    // Funksiyalarni tekshirish: sin, cos, tan, ln, log, √
    if (s.startsWith('sin', pos[0])) {
      pos[0] += 3;
      double arg = _parseUnary(s, pos);
      return math.sin(_isRadians ? arg : arg * math.pi / 180.0);
    }
    if (s.startsWith('cos', pos[0])) {
      pos[0] += 3;
      double arg = _parseUnary(s, pos);
      return math.cos(_isRadians ? arg : arg * math.pi / 180.0);
    }
    if (s.startsWith('tan', pos[0])) {
      pos[0] += 3;
      double arg = _parseUnary(s, pos);
      return math.tan(_isRadians ? arg : arg * math.pi / 180.0);
    }
    if (s.startsWith('ln', pos[0])) {
      pos[0] += 2;
      double arg = _parseUnary(s, pos);
      return math.log(arg);
    }
    if (s.startsWith('log', pos[0])) {
      pos[0] += 3;
      double arg = _parseUnary(s, pos);
      return math.log(arg) / math.ln10;
    }
    if (s.startsWith('√', pos[0])) {
      pos[0] += 1;
      double arg = _parseUnary(s, pos);
      return math.sqrt(arg);
    }

    return _parsePrimary(s, pos);
  }

  double _parsePrimary(String s, List<int> pos) {
    _skipSpaces(s, pos);
    if (pos[0] >= s.length) return 0.0;

    if (s[pos[0]] == '(') {
      pos[0]++;
      double val = _parseAddSub(s, pos);
      _skipSpaces(s, pos);
      if (pos[0] < s.length && s[pos[0]] == ')') pos[0]++;
      return val;
    }

    int start = pos[0];
    while (pos[0] < s.length && RegExp(r'[0-9.]').hasMatch(s[pos[0]])) {
      pos[0]++;
    }

    if (start == pos[0]) return 0.0;
    double val = double.parse(s.substring(start, pos[0]));

    // Factorial postfix '!'
    _skipSpaces(s, pos);
    if (pos[0] < s.length && s[pos[0]] == '!') {
      pos[0]++;
      val = _factorial(val.toInt()).toDouble();
    }

    return val;
  }

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n <= 1) return 1;
    int res = 1;
    for (int i = 2; i <= n && i <= 20; i++) {
      res *= i;
    }
    return res;
  }

  void _skipSpaces(String s, List<int> pos) {
    while (pos[0] < s.length && s[pos[0]] == ' ') {
      pos[0]++;
    }
  }

  String _formatNumber(double val) {
    if (val.isNaN) return 'Xato';
    if (val.isInfinite) return "0 ga bo'lib bo'lmaydi";

    if (val == val.truncateToDouble() && val.abs() < 1e12) {
      return _formatWithCommas(val.toInt().toString());
    } else {
      String s = val.toStringAsFixed(8);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      if (s.length > 14) s = val.toStringAsExponential(4);
      return s;
    }
  }

  String _formatWithCommas(String intStr) {
    bool neg = intStr.startsWith('-');
    String digits = neg ? intStr.substring(1) : intStr;
    String res = '';
    int count = 0;
    for (int i = digits.length - 1; i >= 0; i--) {
      res = digits[i] + res;
      count++;
      if (count % 3 == 0 && i > 0) res = ' ' + res;
    }
    return neg ? '-$res' : res;
  }
}
