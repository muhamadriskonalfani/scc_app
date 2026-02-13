import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../services/auth_service.dart';
import '../../utils/dio_error_handler.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();
  final _studentId = TextEditingController();
  final _entryYear = TextEditingController();
  final _graduationYear = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  List<dynamic> faculties = [];
  List<dynamic> studyPrograms = [];

  String? role;
  String? gender;
  int? facultyId;
  int? studyProgramId;

  @override
  void initState() {
    super.initState();
    _loadRegisterMeta();
  }

  Future<void> _loadRegisterMeta() async {
    try {
      final data = await _authService.registerMeta();
      setState(() {
        faculties = data['faculties'];
        studyPrograms = data['study_programs'];
      });
    } on DioException catch (e) {
      setState(() {
        _error = DioErrorHandler.handle(e);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_password.text != _passwordConfirm.text) {
      setState(() {
        _error = 'Password dan konfirmasi password tidak sama';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.register({
        'name': _name.text,
        'email': _email.text,
        'password': _password.text,
        'password_confirmation': _passwordConfirm.text,
        'role': role,
        'gender': gender,
        'student_id_number': _studentId.text,
        'faculty_id': facultyId,
        'study_program_id': studyProgramId,
        'entry_year': _entryYear.text,
        'graduation_year': _graduationYear.text,
      });

      if (!mounted) return;
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() {
        _error = DioErrorHandler.handle(e);
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 32),

                Image.asset('assets/images/logo.png', width: 64),
                const SizedBox(height: 10),
                const Text(
                  'Student Career Center',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Pusat Karier Mahasiswa',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
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
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        AppInput(
                          label: 'Nama Lengkap',
                          hint: 'Masukkan nama lengkap',
                          controller: _name,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Email',
                          hint: 'Masukkan email',
                          controller: _email,
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Password',
                          hint: 'Masukkan password',
                          controller: _password,
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Konfirmasi Password',
                          hint: 'Ulangi password',
                          controller: _passwordConfirm,
                          icon: Icons.lock_outline,
                          obscureText: _obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        AppDropdown<String>(
                          label: 'Daftar Sebagai',
                          value: role,
                          items: const [
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Mahasiswa'),
                            ),
                            DropdownMenuItem(
                              value: 'alumni',
                              child: Text('Alumni'),
                            ),
                          ],
                          onChanged: (v) => setState(() => role = v),
                        ),
                        const SizedBox(height: 16),

                        AppDropdown<String>(
                          label: 'Gender',
                          value: gender,
                          items: const [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Laki-laki'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Perempuan'),
                            ),
                          ],
                          onChanged: (v) => setState(() => gender = v),
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'NIM / NPM',
                          hint: 'Masukkan NIM / NPM',
                          controller: _studentId,
                          icon: Icons.credit_card_outlined,
                        ),
                        const SizedBox(height: 16),

                        AppDropdown<int>(
                          label: 'Fakultas',
                          value: facultyId,
                          items: faculties
                              .map<DropdownMenuItem<int>>(
                                (f) => DropdownMenuItem<int>(
                                  value: f['id'],
                                  child: Text(
                                    f['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => facultyId = v),
                        ),
                        const SizedBox(height: 16),

                        AppDropdown<int>(
                          label: 'Program Studi',
                          value: studyProgramId,
                          items: studyPrograms
                              .map<DropdownMenuItem<int>>(
                                (p) => DropdownMenuItem<int>(
                                  value: p['id'],
                                  child: Text(
                                    p['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => studyProgramId = v),
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Tahun Masuk',
                          hint: 'Contoh: 2022',
                          controller: _entryYear,
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Tahun Lulus (Opsional)',
                          hint: 'Contoh: 2026',
                          controller: _graduationYear,
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          validator: (_) => null,
                        ),
                        const SizedBox(height: 24),

                        AppButton(
                          label: 'Daftar',
                          icon: Icons.app_registration,
                          isLoading: _loading,
                          onPressed: _submit,
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Sudah punya akun? Login'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
