import 'package:flutter/material.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final Color spinnerColor;
  final Color? backgroundColor;
  final double? strokeWidth;

  const AppCircularProgressIndicator({
    required this.spinnerColor,
    this.backgroundColor,
    this.strokeWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 4,
          color: spinnerColor,
        ),
      ),
    );
  }
}
