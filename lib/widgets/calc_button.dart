import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_theme.dart';

enum ButtonType { number, operator, special, equal, clear }

class CalcButton extends StatefulWidget {
  final String label;
  final ButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final Widget? icon;

  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.onPressed,
    this.fontSize = 26,
    this.icon,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    switch (widget.type) {
      case ButtonType.equal:
        return _buildEqualButton();
      case ButtonType.operator:
        return _buildOperatorButton();
      case ButtonType.special:
      case ButtonType.clear:
        return _buildSpecialButton();
      case ButtonType.number:
        return _buildNumberButton();
    }
  }

  Widget _buildEqualButton() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.equalStart, AppColors.equalEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: widget.icon ??
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    color: Colors.white70,
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildOperatorButton() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.operatorBg,
        border: Border.all(
          color: AppColors.accentPurple.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.operatorText,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.specialBg,
        border: Border.all(
          color: AppColors.accentCyan.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: widget.icon ??
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize * 0.9,
                fontWeight: FontWeight.w600,
                color: AppColors.specialText,
              ),
            ),
      ),
    );
  }

  Widget _buildNumberButton() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.numberBg,
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.numberText,
          ),
        ),
      ),
    );
  }
}
