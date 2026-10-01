import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Fonction d'assistance pour afficher la boîte de dialogue de confirmation.
/// Renvoie `true` si l'utilisateur confirme, `false` sinon.
Future<bool> showConfirmNewGameDialog(BuildContext context) async {
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

  return confirmed ?? false;
}


