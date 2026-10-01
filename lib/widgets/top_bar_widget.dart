import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TopBar extends StatelessWidget {
  final List<int> drawnNumbers;
  final VoidCallback onResetConfirmed;

  const TopBar({
    super.key,
    required this.drawnNumbers,
    required this.onResetConfirmed
  });


  Future<void> _confirmNewGame(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Nouvelle partie ?'),
        content: const Text(
          'Le tirage actuel sera effacé. Voulez-vous vraiment recommencer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Recommencer'),
          ),
        ],
      ),
    );

    // Si l'utilisateur confirme, on déclenche le callback
    if (confirmed == true) {
      onResetConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.casino_rounded, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 11),
        const Text(
          'BINGO',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: drawnNumbers.isEmpty ? null :() => _confirmNewGame(context),
          icon: const Icon(Icons.refresh_rounded, size: 19),
          label: const Text('Nouvelle partie'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

