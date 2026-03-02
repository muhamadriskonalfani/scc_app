import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final AuthService _authService = AuthService();
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await _authService.getToken();

    if (!mounted) return;

    /// Jika belum login
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    /// Jika sudah login → cek biometric
    final supported = await _biometricService.isBiometricAvailable();
    final enrolled = await _biometricService.hasBiometrics();

    print("Biometric Supported: $supported");

    if (supported && enrolled) {
      final authenticated = await _biometricService.authenticate();

      if (!mounted) return;

      if (authenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } else {
      /// Device tidak support biometric → langsung masuk
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: const Center(
            child: Icon(Icons.school, size: 180, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
