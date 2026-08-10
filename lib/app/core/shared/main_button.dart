// lib/app/core/shared/main_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool outlined;

  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        style: outlined
            ? ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                elevation: 0,
              )
            : null,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
