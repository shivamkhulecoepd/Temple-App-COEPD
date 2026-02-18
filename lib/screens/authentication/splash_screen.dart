import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/screens/authentication/language_selection.dart';
import 'package:mslgd/widgets/layout_screen.dart';
import 'package:mslgd/services/storage_service.dart';
import 'package:mslgd/widgets/translated_text.dart';

// ─── Particle Model ──────────────────────────────────────────────────────────

class _Particle {
  double x, y, radius, opacity, speed, angle;
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.speed,
    required this.angle,
  });
}

// ─── Particle Painter ────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;

  _ParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

// ─── Sacred Geometry Painter ──────────────────────────────────────────────────

class _GeometryPainter extends CustomPainter {
  final double rotation;
  final double opacity;
  final Color color;

  _GeometryPainter({
    required this.rotation,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.translate(cx, cy);

    // Draw rotating mandala-like rings
    for (int ring = 1; ring <= 5; ring++) {
      final radius = (size.width * 0.12 * ring).clamp(0.0, size.width * 0.62);
      final ringOpacity = (0.18 - ring * 0.025).clamp(0.0, 1.0);
      paint.color = color.withValues(alpha: ringOpacity);

      // Hexagon at each ring
      final path = Path();
      for (int i = 0; i <= 6; i++) {
        final angle =
            (i * 60 * math.pi / 180) + rotation * (ring.isOdd ? 1 : -1);
        final x = radius * math.cos(angle);
        final y = radius * math.sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);

      // Spokes
      paint.color = color.withValues(alpha: ringOpacity * 0.5);
      for (int i = 0; i < 6; i++) {
        final angle = (i * 60 * math.pi / 180) + rotation;
        canvas.drawLine(
          Offset.zero,
          Offset(radius * math.cos(angle), radius * math.sin(angle)),
          paint,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GeometryPainter old) =>
      old.rotation != rotation || old.opacity != opacity;
}

// ─── Splash Screen ────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Main entry animation
  late AnimationController _entryController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _subtitleFade;
  late Animation<double> _loaderFade;

  // Background geometry rotation
  late AnimationController _geoController;

  // Glow pulse
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // Particles
  final List<_Particle> _particles = [];
  late AnimationController _particleController;
  final math.Random _rng = math.Random();
  Timer? _particleTimer;

  // ─── Colors ──────────────────────────────────────────────────────────────

  static const Color _bgTop = Color(0xFF0D0A1A);
  static const Color _bgMid = Color(0xFF1A0E2E);
  static const Color _bgBot = Color(0xFF0F1A2E);
  static const Color _gold = Color(0xFFD4A853);
  static const Color _goldLight = Color(0xFFF5C96A);
  static const Color _amber = Color(0xFFFFB347);
  static const Color _cream = Color(0xFFFFF8E7);

  @override
  void initState() {
    super.initState();
    _initParticles();
    _initControllers();
    _checkAuthStatus();
  }

  void _initParticles() {
    for (int i = 0; i < 55; i++) {
      _particles.add(
        _Particle(
          x: _rng.nextDouble(),
          y: _rng.nextDouble(),
          radius: _rng.nextDouble() * 2.2 + 0.4,
          opacity: _rng.nextDouble() * 0.45 + 0.08,
          speed: _rng.nextDouble() * 0.0008 + 0.0002,
          angle: _rng.nextDouble() * math.pi * 2,
        ),
      );
    }
  }

  void _initControllers() {
    // Entry animation — staggered reveals
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.40, curve: Curves.elasticOut),
      ),
    );
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.30, 0.60, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
          ),
        );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.80, curve: Curves.easeIn),
      ),
    );
    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // Geometry rotation — infinite slow spin
    _geoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();

    // Glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Particle ticker
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _particleController.addListener(_updateParticles);

    _entryController.forward();
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      for (final p in _particles) {
        p.x += math.cos(p.angle) * p.speed;
        p.y += math.sin(p.angle) * p.speed;
        // Gentle drift direction change
        p.angle += ((_rng.nextDouble() - 0.5) * 0.04);
        // Wrap around
        if (p.x < 0) p.x = 1.0;
        if (p.x > 1) p.x = 0.0;
        if (p.y < 0) p.y = 1.0;
        if (p.y > 1) p.y = 0.0;
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    try {
      final storageService = context.read<StorageService>();
      final isFirstLaunch = await storageService.isFirstLaunch();
      if (!mounted) return;

      if (isFirstLaunch) {
        await storageService.setFirstLaunch(false);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
        );
      } else {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LayoutScreen()),
            (route) => false,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LayoutScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _geoController.dispose();
    _glowController.dispose();
    _particleController.removeListener(_updateParticles);
    _particleController.dispose();
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gradient Background ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_bgTop, _bgMid, _bgBot],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Radial Glow Center ──
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, __) => Center(
              child: Container(
                width: size.width * 1.1,
                height: size.width * 1.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _gold.withValues(alpha: 0.10 * _glowAnim.value),
                      _gold.withValues(alpha: 0.04 * _glowAnim.value),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── Floating Particles ──
          CustomPaint(
            painter: _ParticlePainter(particles: _particles, color: _goldLight),
          ),

          // ── Sacred Geometry ──
          AnimatedBuilder(
            animation: _geoController,
            builder: (_, __) => CustomPaint(
              painter: _GeometryPainter(
                rotation: _geoController.value * math.pi * 2,
                opacity: 1.0,
                color: _gold,
              ),
            ),
          ),

          // ── Top decorative arch line ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.32),
              painter: _ArchPainter(color: _gold.withValues(alpha: 0.12)),
            ),
          ),

          // ── Main Content ──
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo with glow ring ──
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoFade,
                      _logoScale,
                      _glowAnim,
                    ]),
                    builder: (_, __) => Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            Container(
                              width: 108.w,
                              height: 108.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _gold.withValues(
                                      alpha: 0.28 * _glowAnim.value,
                                    ),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            // Gradient ring border
                            Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    _gold.withValues(alpha: 0.0),
                                    _goldLight,
                                    _amber,
                                    _gold.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                            // Inner fill
                            Container(
                              width: 94.w,
                              height: 94.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF2A1A4A),
                                    const Color(0xFF150D28),
                                  ],
                                ),
                              ),
                            ),
                            // Logo image
                            SizedBox(
                              width: 64.w,
                              height: 64.w,
                              child: Image.asset(
                                'assets/images/about/temple_logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.temple_hindu,
                                  size: 38.r,
                                  color: _gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // ── Gold divider dot row ──
                  AnimatedBuilder(
                    animation: _textFade,
                    builder: (_, __) => Opacity(
                      opacity: _textFade.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDividerLine(),
                          SizedBox(width: 8.w),
                          Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _gold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _buildDividerLine(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Temple Name ──
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_goldLight, _gold, _amber],
                        ).createShader(bounds),
                        child: TranslatedText(
                          "Marakatha Sri Lakshmi\nGanapathi Devasthanam",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white, // Masked by shader
                            height: 1.4,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ── Subtitle ──
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: _gold.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                          bottom: BorderSide(
                            color: _gold.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: TranslatedText(
                        "Divine Blessings  •  Peace  •  Prosperity",
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 12.sp,
                          color: _cream.withValues(alpha: 0.72),
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 52.h),

                  // ── Loader ──
                  FadeTransition(
                    opacity: _loaderFade,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 28.w,
                          height: 28.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              _gold,
                            ),
                            backgroundColor: _gold.withValues(alpha: 0.15),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TranslatedText(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: _cream.withValues(alpha: 0.38),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Om / Sanskrit watermark ──
          Positioned(
            bottom: 24.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _subtitleFade,
              child: Text(
                'ॐ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: _gold.withValues(alpha: 0.18),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividerLine() {
    return Container(
      width: 40.w,
      height: 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, _gold, Colors.transparent],
        ),
      ),
    );
  }
}

// ─── Arch Painter ─────────────────────────────────────────────────────────────

class _ArchPainter extends CustomPainter {
  final Color color;
  _ArchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Top decorative arch curves
    for (int i = 0; i < 3; i++) {
      final offsetY = i * 12.0;
      final path = Path()
        ..moveTo(0, offsetY)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.5 + offsetY,
          size.width,
          offsetY,
        );
      canvas.drawPath(
        path,
        paint..color = color.withValues(alpha: 0.06 * (3 - i)),
      );
    }
  }

  @override
  bool shouldRepaint(_ArchPainter old) => false;
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mslgd/screens/authentication/language_selection.dart';
// import 'package:mslgd/widgets/layout_screen.dart';
// import 'package:mslgd/services/storage_service.dart';
// import 'package:mslgd/widgets/translated_text.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1600),
//     );

//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

//     _controller.forward();

//     // Check auth status immediately
//     _checkAuthStatus();
//   }

//   Future<void> _checkAuthStatus() async {
//     await Future.delayed(const Duration(seconds: 3));
    
//     if (!mounted) return;
    
//     try {
//       final storageService = context.read<StorageService>();
//       final isFirstLaunch = await storageService.isFirstLaunch();
      
//       if (!mounted) return;
      
//       if (isFirstLaunch) {
//         // Mark as not first launch anymore
//         await storageService.setFirstLaunch(false);
//         if (!mounted) return;
        
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => const LanguageSelectionScreen(),
//           ),
//         );
//       } else {
//         // Go directly to main app without requiring login
//         if (mounted) {
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => const LayoutScreen(),
//             ),
//             (route) => false,
//           );
//         }
//       }
//     } catch (e) {
//       // Fallback to main app on error
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (context) => const LayoutScreen(),
//           ),
//           (route) => false,
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Center(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Ganapathi / Temple Symbol
//                   Image.asset(
//                     'assets/images/about/temple_logo.png',
//                     height: 72.h,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 72.h,
//                         width: 72.w,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Icon(
//                           Icons.temple_hindu,
//                           size: 36.r,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       );
//                     },
//                   ),

//                   SizedBox(height: 28.h),

//                   // Temple Name
//                   TranslatedText(
//                     "Marakatha Sri Lakshmi\nGanapathi Devasthanam",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'aBeeZee',
//                       fontSize: 26.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Theme.of(context).colorScheme.onSurface,
//                       height: 1.3,
//                     ),
//                   ),

//                   SizedBox(height: 14.h),

//                   // Subtitle
//                   TranslatedText(
//                     "Divine Blessings • Peace • Prosperity",
//                     style: TextStyle(
//                       fontFamily: 'inter',
//                       fontSize: 14.sp,
//                       color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
//                       letterSpacing: 0.8,
//                     ),
//                   ),

//                   SizedBox(height: 36.h),

//                   // Loader
//                   SizedBox(
//                     width: 32.w,
//                     height: 32.h,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3.0,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).colorScheme.secondary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }