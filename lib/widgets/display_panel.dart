import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class DisplayPanel extends StatelessWidget {
  final String display;
  final String history;
  final bool hasError;

  const DisplayPanel({
    super.key,
    required this.display,
    required this.history,
    this.hasError = false,
  });

  double _getFontSize(String text) {
    if (text.length <= 6) return 72;
    if (text.length <= 9) return 58;
    if (text.length <= 12) return 46;
    if (text.length <= 15) return 36;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgPrimary,
            AppColors.bgSecondary,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accentPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // History row
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: history.isNotEmpty
                ? Text(
                    key: ValueKey(history),
                    history,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.displaySubText,
                      letterSpacing: 0.5,
                    ),
                  )
                : const SizedBox(height: 22),
          ),
          const SizedBox(height: 8),
          // Main display
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              key: ValueKey(display),
              display,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _getFontSize(display),
                fontWeight: FontWeight.w300,
                color: hasError
                    ? const Color(0xFFFF5252)
                    : AppColors.displayText,
                letterSpacing: -1,
                shadows: hasError
                    ? []
                    : [
                        Shadow(
                          color: AppColors.accentCyan.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
