import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40, this.fit = BoxFit.contain});

  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.22;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'logoapp.png',
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported_outlined,
            size: size,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
