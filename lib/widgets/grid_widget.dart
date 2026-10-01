import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GridWidget extends StatelessWidget {

  final List<int> drawnNumbers;
  final int? lastDrawn;

  Set<int> get drawnSet => drawnNumbers.toSet();

  const GridWidget({
    super.key,
    required this.drawnNumbers,
    required this.lastDrawn
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                'GRILLE',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Déjà tiré',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.textSecondary),
          ),
          child: Column(
            children: [
              for (var row = 0; row < 15; row++)
                Padding(
                  padding: EdgeInsets.only(bottom: row == 14 ? 0 : 5),
                  child: Row(
                    children: [
                      for (var column = 0; column < 5; column++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _NumberCell(
                              number: row * 5 + column + 1,
                              isDrawn: drawnSet.contains(row * 5 + column + 1),
                              isLatest: lastDrawn == row * 5 + column + 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        )
      ],
    )
     ;
  }
}



class _NumberCell extends StatelessWidget {
  const _NumberCell({
    required this.number,
    required this.isDrawn,
    required this.isLatest,
  });

  final int number;
  final bool isDrawn;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final color = isDrawn ? AppColors.secondary : AppColors.background;
    return Container(
      key: ValueKey('number-$number'),
      height: 34,
      decoration: BoxDecoration(
        color: isLatest ? AppColors.primary : color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color:  AppColors.textSecondary),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          color: isDrawn? AppColors.background : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isLatest ? FontWeight.w900 : FontWeight.w600,
        ),
      ),
    );
  }
}