import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: gradient,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradient() {
    switch (type) {
      case AppButtonType.secondary:
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
        );
      case AppButtonType.danger:
        return const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
        );
      case AppButtonType.primary:
        return const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        );
    }
  }
}
