import 'package:flutter/material.dart';

class KDropdownItem<T> {
  final T value;
  final String label;

  KDropdownItem({required this.value, required this.label});
}

class KDropdown<T> extends StatelessWidget {
  final List<KDropdownItem<T>> items;
  final T? value;
  final String? labelText;
  final String? hintText;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const KDropdown({
    super.key,
    required this.items,
    this.value,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.disabledColor.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
      ),
    );
  }
}
