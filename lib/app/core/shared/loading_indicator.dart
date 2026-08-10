// lib/app/core/shared/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatelessWidget {
  final double? height;
  final Color? color;

  const LoadingIndicator({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 200.h,
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
