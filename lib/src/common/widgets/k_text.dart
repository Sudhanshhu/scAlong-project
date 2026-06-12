import 'package:flutter/material.dart';

enum KTextStyle {
  displayLarge,
  displayMedium,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  labelLarge,
}

class KText extends StatelessWidget {
  final String text;
  final KTextStyle style;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KText(
    this.text, {
    super.key,
    this.style = KTextStyle.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle? textStyle;

    switch (style) {
      case KTextStyle.displayLarge:
        textStyle = theme.textTheme.displayLarge;
        break;
      case KTextStyle.displayMedium:
        textStyle = theme.textTheme.displayMedium;
        break;
      case KTextStyle.titleLarge:
        textStyle = theme.textTheme.titleLarge;
        break;
      case KTextStyle.titleMedium:
        textStyle = theme.textTheme.titleMedium;
        break;
      case KTextStyle.bodyLarge:
        textStyle = theme.textTheme.bodyLarge;
        break;
      case KTextStyle.bodyMedium:
        textStyle = theme.textTheme.bodyMedium;
        break;
      case KTextStyle.labelLarge:
        textStyle = theme.textTheme.labelLarge;
        break;
    }

    if (textStyle != null) {
      textStyle = textStyle.copyWith(
        color: color ?? theme.colorScheme.onSurface,
        fontWeight: fontWeight ?? textStyle.fontWeight,
      );
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
