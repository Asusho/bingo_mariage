import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawInfoWidget extends StatelessWidget {
  final int remaining;

  const DrawInfoWidget({
    super.key,
    required this.remaining
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 1),
        Text(
          '$remaining numéros restants sur 75',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }
}