import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DateFormat(..., 'fr_FR') (mois, jours) exige les données de locale.
  await initializeDateFormatting('fr_FR');
  runApp(const ProviderScope(child: MonAtelierApp()));
}

class MonAtelierApp extends StatelessWidget {
  const MonAtelierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Couturier',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppSplashScreen(),
    );
  }
}

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeScale;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeScale =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();

    _navigationTimer = Timer(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeScale,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  painter: _StitchCirclePainter(color: cs.primary),
                  child: SizedBox(
                    width: 176,
                    height: 176,
                    child: Center(
                      child: Container(
                        width: 116,
                        height: 116,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.content_cut,
                            size: 58, color: cs.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Dev Couturier',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GESTION DE COUTURE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: cs.primary,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: cs.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StitchCirclePainter extends CustomPainter {
  final Color color;
  _StitchCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    const dash = 5.0;
    const gap = 5.0;
    final path = Path()..addOval(rect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
