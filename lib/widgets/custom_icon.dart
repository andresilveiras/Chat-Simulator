import 'package:flutter/material.dart';

/// Widget de emoji/texto para máxima compatibilidade
class CustomIcon extends StatelessWidget {
  final String emoji;
  final double size;
  final Color? color;

  const CustomIcon({
    super.key,
    required this.emoji,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}

/// Widget de avatar personalizado usando emoji ou inicial
class CustomAvatar extends StatelessWidget {
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final String? text;
  final String? emoji;

  const CustomAvatar({
    super.key,
    this.radius = 24.0,
    required this.backgroundColor,
    required this.textColor,
    this.text,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: emoji != null
          ? Text(
              emoji!,
              style: TextStyle(
                color: textColor,
                fontSize: radius * 0.8,
              ),
            )
          : Text(
              text ?? '💬',
              style: TextStyle(
                color: textColor,
                fontSize: radius * 0.7,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
} 