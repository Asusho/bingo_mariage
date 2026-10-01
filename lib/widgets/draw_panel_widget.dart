import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawPanelWidget extends StatelessWidget {
  final int? number;
  final List<int> remainingNumbers;
  final List<int> drawnNumbers;
  final VoidCallback drawNumber;


  const DrawPanelWidget({
    super.key,
    required this.number,
    required this.remainingNumbers,
    required this.drawnNumbers,
    required this.drawNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.16),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'NUMÉRO TIRÉ',
              style: TextStyle(
                color: AppColors.background,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Container(
                key: ValueKey(number),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      number?.toString().padLeft(2, '0') ?? '--',
                      style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 54,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 19),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: remainingNumbers.isEmpty ? null : drawNumber,
                icon: AnimatedRotation(
                  turns: drawnNumbers.length.toDouble(),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    remainingNumbers.isEmpty
                        ? Icons.check_circle_outline_rounded
                        : Icons.casino_rounded,
                    size: 21,
                  ),
                ),
                label: Text(
                  remainingNumbers.isEmpty
                      ? 'Partie terminée'
                      : 'Tirer un numéro',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textSecondary,
                  disabledBackgroundColor: AppColors.textMuted,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
