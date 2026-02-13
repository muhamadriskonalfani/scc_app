import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../config/dio_client.dart';
import '../../services/apprenticeship/apprenticeship_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';

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
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        companyName: _companyCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        expiredAt: _expiredCtrl.text.isNotEmpty ? _expiredCtrl.text : null,
        image: _image,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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

  Widget _imageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 160,
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _datePickerField() {
    return AppInput(
      label: 'Tanggal Berakhir (Opsional)',
      hint: 'Pilih tanggal berakhir',
      controller: _expiredCtrl,
      icon: Icons.calendar_today_outlined,
      validator: (_) => null,
      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
      keyboardType: TextInputType.datetime,
      obscureText: false,
      maxLines: 1,
    );
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _imageSection(),

                AppInput(
                  label: 'Judul Magang',
                  hint: 'Masukkan judul magang',
                  controller: _titleCtrl,
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Nama Perusahaan',
                  hint: 'Masukkan nama perusahaan',
                  controller: _companyCtrl,
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Lokasi',
                  hint: 'Masukkan lokasi magang',
                  controller: _locationCtrl,
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Deskripsi',
                  hint: 'Tuliskan deskripsi magang',
                  controller: _descriptionCtrl,
                  icon: Icons.description_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),

                GestureDetector(
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
                  child: AbsorbPointer(child: _datePickerField()),
                ),

                const SizedBox(height: 24),

                AppButton(
                  label: 'Simpan Informasi',
                  icon: Icons.save_outlined,
                  isLoading: _loading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
