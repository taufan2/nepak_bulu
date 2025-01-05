import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MobileWebLayout extends StatelessWidget {
  final Widget child;

  const MobileWebLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Hanya terapkan di web
    if (!kIsWeb) return child;

    return ColoredBox(
      color:
          Colors.grey[100]!, // Background color untuk area di luar mobile view
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 480, // Standar lebar mobile
          ),
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
