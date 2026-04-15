import 'dart:math' as math;
import 'package:flutter/material.dart';



// ─── Splash Screen ────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late AnimationController _pulseController;

  // Logo animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotate;

  // Text animations
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  // Background
  late Animation<double> _bgOpacity;

  // Pulse
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bgOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeIn),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.15), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.1, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Sequence the animations
    _bgController.forward().then((_) {
      _logoController.forward().then((_) {
        _textController.forward();
      });
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _logoController,
          _textController,
          _dotsController,
          _pulseController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _bgOpacity,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D0D1A),
                    Color(0xFF12102B),
                    Color(0xFF0A1628),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative blobs
                  _buildBlob(
                    top: -80,
                    left: -60,
                    size: 280,
                    color: const Color(0xFF6C63FF).withOpacity(0.18),
                    scale: _pulse.value,
                  ),
                  _buildBlob(
                    bottom: -100,
                    right: -80,
                    size: 320,
                    color: const Color(0xFFFF6584).withOpacity(0.12),
                    scale: 2.0 - _pulse.value,
                  ),
                  _buildBlob(
                    top: 200,
                    right: -40,
                    size: 180,
                    color: const Color(0xFF43E8D8).withOpacity(0.10),
                    scale: _pulse.value * 0.95,
                  ),

                  // Subtle grid pattern
                  CustomPaint(
                    size: Size.infinite,
                    painter: _GridPainter(),
                  ),

                  // Main content
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),

                        // Logo mark
                        Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotate.value,
                            child: Opacity(
                              opacity: _logoOpacity.value.clamp(0.0, 1.0),
                              child: _buildLogo(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // App name
                        SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleOpacity,
                            child: _buildTitle(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tagline
                        SlideTransition(
                          position: _taglineSlide,
                          child: FadeTransition(
                            opacity: _taglineOpacity,
                            child: _buildTagline(),
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Loading dots
                        FadeTransition(
                          opacity: _taglineOpacity,
                          child: _buildLoadingDots(),
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double scale,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B7FFF),
            Color(0xFF6C63FF),
            Color(0xFF5A4FD6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.55),
            blurRadius: 40,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.20),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chat bubble icon custom-drawn
          CustomPaint(
            size: const Size(58, 52),
            painter: _ChatBubblePainter(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFD4CFFF),
        ],
      ).createShader(bounds),
      child: const Text(
        'laghini',
        style: TextStyle(
          fontFamily: 'Georgia', // elegant serif
          fontSize: 52,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 1,
          color: const Color(0xFF6C63FF).withOpacity(0.6),
        ),
        const SizedBox(width: 10),
        Text(
          'where conversations come alive',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 24,
          height: 1,
          color: const Color(0xFF6C63FF).withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final t = (_dotsController.value - i * 0.2).clamp(0.0, 1.0);
        final opacity = (math.sin(t * math.pi * 2)).abs().clamp(0.2, 1.0);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6C63FF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Custom Painters ──────────────────────────────────────────────────────────

class _ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Main bubble
    final bubblePath = Path();
    final r = 10.0;
    bubblePath.moveTo(r, 0);
    bubblePath.lineTo(w - r, 0);
    bubblePath.quadraticBezierTo(w, 0, w, r);
    bubblePath.lineTo(w, h * 0.65);
    bubblePath.quadraticBezierTo(w, h * 0.65 + r, w - r, h * 0.65 + r);
    bubblePath.lineTo(w * 0.45, h * 0.65 + r);
    bubblePath.lineTo(w * 0.28, h); // tail
    bubblePath.lineTo(w * 0.28, h * 0.65 + r);
    bubblePath.lineTo(r, h * 0.65 + r);
    bubblePath.quadraticBezierTo(0, h * 0.65 + r, 0, h * 0.65);
    bubblePath.lineTo(0, r);
    bubblePath.quadraticBezierTo(0, 0, r, 0);
    bubblePath.close();

    canvas.drawPath(bubblePath, paint);

    // Dots inside bubble
    final dotPaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..style = PaintingStyle.fill;

    final dotY = (h * 0.65 + r) / 2;
    canvas.drawCircle(Offset(w * 0.28, dotY), 4, dotPaint);
    canvas.drawCircle(Offset(w * 0.50, dotY), 4, dotPaint);
    canvas.drawCircle(Offset(w * 0.72, dotY), 4, dotPaint);

    // Second smaller bubble (reply)
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final bubble2 = Path();
    final x2 = w * 0.30;
    final y2 = h * 0.72;
    final w2 = w * 0.65;
    final h2 = h * 0.25;
    final r2 = 8.0;

    bubble2.moveTo(x2 + r2, y2);
    bubble2.lineTo(x2 + w2 - r2, y2);
    bubble2.quadraticBezierTo(x2 + w2, y2, x2 + w2, y2 + r2);
    bubble2.lineTo(x2 + w2, y2 + h2 - r2);
    bubble2.quadraticBezierTo(x2 + w2, y2 + h2, x2 + w2 - r2, y2 + h2);
    bubble2.lineTo(x2 + w2 * 0.55, y2 + h2);
    bubble2.lineTo(x2 + w2 * 0.7, y2 + h2 + 6); // small tail right
    bubble2.lineTo(x2 + w2 * 0.75, y2 + h2);
    bubble2.lineTo(x2 + r2, y2 + h2);
    bubble2.quadraticBezierTo(x2, y2 + h2, x2, y2 + h2 - r2);
    bubble2.lineTo(x2, y2 + r2);
    bubble2.quadraticBezierTo(x2, y2, x2 + r2, y2);
    bubble2.close();

    canvas.drawPath(bubble2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}