import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../config/dio_client.dart';
import '../../services/apprenticeship/apprenticeship_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class ApprenticeshipCreate extends StatefulWidget {
  const ApprenticeshipCreate({super.key});

  @override
  State<ApprenticeshipCreate> createState() => _ApprenticeshipCreateState();
}

class _ApprenticeshipCreateState extends State<ApprenticeshipCreate> {
  final _formKey = GlobalKey<FormState>();
  final _service = ApprenticeshipService(DioClient.instance);

  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _expiredCtrl = TextEditingController();

  File? _image;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _service.createApprenticeship(
        title: _titleCtrl.text,
        description: _descriptionCtrl.text,
        companyName: _companyCtrl.text,
        location: _locationCtrl.text,
        expiredAt: _expiredCtrl.text.isNotEmpty ? _expiredCtrl.text : null,
        image: _image,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.apprenticeship);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan informasi magang')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _expiredCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: const AppHeader(title: 'Tambah Info Magang', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _imageSection(),
                _inputField('Judul Magang', _titleCtrl, required: true),
                _inputField('Nama Perusahaan', _companyCtrl, required: true),
                _inputField('Lokasi', _locationCtrl, required: true),
                _textareaField('Deskripsi', _descriptionCtrl, required: true),
                _dateField(),
                const SizedBox(height: 20),
                _saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade200,
              image: _image != null
                  ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _image == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Wajib diisi' : null
            : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _textareaField(
    String label,
    TextEditingController controller, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Wajib diisi' : null
            : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: _expiredCtrl,
        readOnly: true,
        decoration: _inputDecoration('Tanggal Berakhir (Opsional)').copyWith(
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            _expiredCtrl.text = DateFormat('yyyy-MM-dd').format(date);
          }
        },
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: _loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff2563eb), Color(0xff1e40af)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : const Text(
                    'Simpan Informasi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff2563eb)),
      ),
    );
  }
}
