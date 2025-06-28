import 'package:flutter/material.dart';
import 'dart:io';

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
  final String? imageUrl;

  const CustomAvatar({
    super.key,
    this.radius = 24.0,
    required this.backgroundColor,
    required this.textColor,
    this.text,
    this.emoji,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar se é uma URL local válida
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Se for uma URL local temporária (nossa versão sem Firebase Storage)
      if (imageUrl!.startsWith('local://')) {
        // Mostrar emoji com indicador de que tem imagem processada
        return CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                emoji ?? '💬',
                style: TextStyle(
                  color: textColor,
                  fontSize: radius * 0.8,
                ),
              ),
              // Indicador de que tem imagem processada
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: radius * 0.4,
                  height: radius * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: backgroundColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      
      // Se for uma URL de arquivo local válida
      if (imageUrl!.startsWith('file://')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          backgroundImage: FileImage(File(imageUrl!.substring(7))),
        );
      }
      
      // Se for uma URL de rede válida
      if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          backgroundImage: NetworkImage(imageUrl!),
        );
      }
    }
    
    // Fallback: mostrar emoji ou inicial
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