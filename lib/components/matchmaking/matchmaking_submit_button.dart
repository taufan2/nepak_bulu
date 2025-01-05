import 'package:flutter/material.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';

class MatchmakingSubmitButton extends StatelessWidget {
  final bool disabled;
  final bool loading;
  final Function(List<PlayerFirestoreModel>) onSubmit;
  final List<PlayerFirestoreModel> checkedPlayers;

  const MatchmakingSubmitButton({
    super.key,
    this.disabled = false,
    this.loading = false,
    required this.onSubmit,
    required this.checkedPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: disabled ? 0 : 2,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(120, 48),
        maximumSize: const Size(200, 48),
        visualDensity: VisualDensity.compact,
        enableFeedback: true,
        splashFactory: InkRipple.splashFactory,
        animationDuration: const Duration(milliseconds: 200),
      ),
      onPressed: disabled ? null : () => onSubmit(checkedPlayers),
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "MULAI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                if (!disabled) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
    );
  }
}
