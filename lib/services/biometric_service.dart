import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// ===============================
  /// CEK DEVICE SUPPORT BIOMETRIC
  /// ===============================
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  /// ===============================
  /// CEK ADA BIOMETRIC TERDAFTAR
  /// ===============================
  Future<bool> hasBiometrics() async {
    try {
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// ===============================
  /// AUTHENTICATE (FINGERPRINT / FACE)
  /// ===============================
  Future<bool> authenticate() async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Verifikasi untuk masuk ke aplikasi',
        options: const AuthenticationOptions(
          biometricOnly: true, // hanya biometric
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return isAuthenticated;
    } on PlatformException {
      return false;
    }
  }
}
