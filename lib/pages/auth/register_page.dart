import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../services/auth_service.dart';
import '../../utils/dio_error_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Controllers
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

  // Dropdown data
  List<dynamic> faculties = [];
  List<dynamic> studyPrograms = [];

  String? role;
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
        'student_id_number': _studentId.text,
        'faculty_id': facultyId,
        'study_program_id': studyProgramId,
        'entry_year': _entryYear.text,
        'graduation_year': _graduationYear.text,
      });

      if (!mounted) return;

      Navigator.pop(context); // kembali ke Login
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

                // ===== BRAND =====
                Column(
                  children: [
                    Image.asset('assets/images/logo.png', width: 64),
                    const SizedBox(height: 10),
                    const Text(
                      'Student Career Center',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Pusat Karier Mahasiswa',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ===== CARD =====
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
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
                        const SizedBox(height: 20),

                        _input('Nama Lengkap', _name, Icons.person),
                        _input(
                          'Email',
                          _email,
                          Icons.mail,
                          keyboard: TextInputType.emailAddress,
                        ),

                        _passwordInput(
                          'Password',
                          _password,
                          _obscurePassword,
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),

                        _passwordInput(
                          'Konfirmasi Password',
                          _passwordConfirm,
                          _obscureConfirm,
                          () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),

                        _dropdown('Daftar Sebagai', role, const [
                          DropdownMenuItem(
                            value: 'student',
                            child: Text('Mahasiswa'),
                          ),
                          DropdownMenuItem(
                            value: 'alumni',
                            child: Text('Alumni'),
                          ),
                        ], (v) => setState(() => role = v)),

                        _input('NIM / NPM', _studentId, Icons.credit_card),

                        _dropdown(
                          'Fakultas',
                          facultyId,
                          faculties
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f['id'],
                                  child: Text(f['name']),
                                ),
                              )
                              .toList(),
                          (v) => setState(() => facultyId = v as int?),
                        ),

                        _dropdown(
                          'Program Studi',
                          studyProgramId,
                          studyPrograms
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p['id'],
                                  child: Text(p['name']),
                                ),
                              )
                              .toList(),
                          (v) => setState(() => studyProgramId = v as int?),
                        ),

                        _input(
                          'Tahun Masuk',
                          _entryYear,
                          Icons.calendar_today,
                          keyboard: TextInputType.number,
                        ),
                        _input(
                          'Tahun Lulus (opsional)',
                          _graduationYear,
                          Icons.calendar_today,
                          keyboard: TextInputType.number,
                          required: false,
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const CircularProgressIndicator()
                                : const Text('Daftar'),
                          ),
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 12),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== COMPONENTS =====

  Widget _input(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
            required && (v == null || v.isEmpty) ? '$label wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _passwordInput(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (v) => v == null || v.isEmpty ? '$label wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _dropdown<T>(
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: (v) => v == null ? '$label wajib dipilih' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
