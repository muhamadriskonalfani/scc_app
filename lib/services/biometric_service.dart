import 'dart:math';
import 'dart:convert';

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:biometric_storage/biometric_storage.dart';

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

  /// ===============================
  /// BUAT CREDENTIAL BIOMETRIC
  /// ===============================
  Future<String> generateCredential() async {
    final random = Random.secure();

    final bytes = List<int>.generate(32, (_) => random.nextInt(256));

    return base64UrlEncode(bytes);
  }

  /// ===============================
  /// SIMPAN CREDENTIAL BIOMETRIC
  /// ===============================
  Future<void> saveCredential(String credential) async {
    final storage = await BiometricStorage().getStorage(
      'scc_biometric_credential',
      options: StorageFileInitOptions(authenticationRequired: true),
    );

    await storage.write(credential);
  }

  /// ===============================
  /// AMBIL CREDENTIAL BIOMETRIC
  /// ===============================
  Future<String?> getCredential() async {
    try {
      final storage = await BiometricStorage().getStorage(
        'scc_biometric_credential',
        options: StorageFileInitOptions(authenticationRequired: true),
      );

      return await storage.read();
    } catch (_) {
      return null;
    }
  }

  /// ===============================
  /// HAPUS CREDENTIAL BIOMETRIC
  /// ===============================
  Future<void> deleteCredential() async {
    try {
      final storage = await BiometricStorage().getStorage(
        'scc_biometric_credential',
        options: StorageFileInitOptions(authenticationRequired: true),
      );

      await storage.delete();
    } catch (_) {}
  }
}
