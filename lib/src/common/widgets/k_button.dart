import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'k_text.dart';

enum KButtonType {
  primary,
  secondary,
  text,
}

class KButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final KButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const KButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = KButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Widget content = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == KButtonType.primary
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              KText(
                text,
                style: KTextStyle.labelLarge,
                fontWeight: FontWeight.bold,
                color: type == KButtonType.primary
                    ? Colors.white
                    : (onPressed == null
                        ? theme.disabledColor
                        : theme.colorScheme.primary),
              ),
            ],
          );

    final buttonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: Size(width ?? double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    if (type == KButtonType.secondary) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: onPressed == null
                  ? theme.disabledColor
                  : theme.colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: content,
        ),
      );
    }

    if (type == KButtonType.text) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(width ?? 80, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: content,
      );
    }

    // Default primary elevated button
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return theme.disabledColor.withOpacity(0.12);
            }
            return AppTheme.primaryEmerald;
          }),
        ),
        child: content,
      ),
    );
  }
}
