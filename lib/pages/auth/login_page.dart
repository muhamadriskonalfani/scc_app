import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/dio_error_handler.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  final BiometricService _biometricService = BiometricService();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      await _askEnableBiometric();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = DioErrorHandler.handle(e);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Terjadi kesalahan';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Cek apakah perangkat mendukung biometric
      final available = await _biometricService.isBiometricAvailable();
      final enrolled = await _biometricService.hasBiometrics();

      if (!available || !enrolled) {
        if (!mounted) return;

        setState(() {
          _errorMessage =
              'Fingerprint belum tersedia atau belum didaftarkan pada perangkat.';
        });

        return;
      }

      // 2. Ambil credential yang tersimpan
      //    Credential dilindungi oleh biometric
      final credential = await _biometricService.getCredential();

      if (!mounted) return;

      if (credential == null || credential.isEmpty) {
        setState(() {
          _errorMessage =
              'Login fingerprint belum diaktifkan. Silakan login menggunakan email dan password terlebih dahulu.';
        });

        return;
      }

      // 3. Kirim credential ke Laravel
      //    Laravel akan memvalidasi credential
      //    dan memberikan Sanctum token baru
      await _authService.biometricLogin(credential);

      if (!mounted) return;

      // 4. Masuk ke dashboard
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = DioErrorHandler.handle(e);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Terjadi kesalahan saat login menggunakan fingerprint.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _askEnableBiometric() async {
    final enable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aktifkan Fingerprint'),
          content: const Text(
            'Apakah Anda ingin menggunakan fingerprint '
            'untuk login berikutnya?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Aktifkan'),
            ),
          ],
        );
      },
    );

    if (enable != true) return;

    try {
      final available = await _biometricService.isBiometricAvailable();

      final enrolled = await _biometricService.hasBiometrics();

      if (!available || !enrolled) return;

      final credential = await _biometricService.generateCredential();

      await _authService.registerBiometric(credential);

      await _biometricService.saveCredential(credential);
    } catch (_) {
      // Jika gagal mengaktifkan biometric,
      // user tetap bisa masuk menggunakan password.
    }
  }

  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final DateTime now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;

          Fluttertoast.showToast(
            msg: "Ketuk 2 kali untuk keluar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );

          return;
        }

        // Keluar dari aplikasi
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFEAF3FF)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ================= BRAND =================
                  Column(
                    children: [
                      Image.asset('assets/images/logo.png', width: 64),
                      const SizedBox(height: 12),
                      const Text(
                        'Student Career Center',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pusat Karier Mahasiswa',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ================= CARD =================
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ================= EMAIL =================
                          AppInput(
                            label: 'Email',
                            hint: 'Masukkan email',
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 18),

                          // ================= PASSWORD =================
                          AppInput(
                            label: 'Password',
                            hint: 'Masukkan password',
                            controller: _passwordController,
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ================= BUTTON =================
                          AppButton(
                            label: 'Login',
                            icon: Icons.login,
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'atau',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),

                          const SizedBox(height: 16),

                          TextButton.icon(
                            onPressed: _isLoading
                                ? null
                                : _handleBiometricLogin,
                            icon: const Icon(Icons.fingerprint),
                            label: const Text('Login dengan Fingerprint'),
                          ),

                          const SizedBox(height: 20),

                          // ================= LINKS =================
                          Column(
                            children: [
                              // TextButton(
                              //   onPressed: () {},
                              //   child: const Text('Lupa password?'),
                              // ),
                              // const Text(
                              //   'or',
                              //   style: TextStyle(color: Colors.grey),
                              // ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.register,
                                  );
                                },
                                child: const Text('Belum punya akun? Daftar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
