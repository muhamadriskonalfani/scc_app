import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';
import '../../services/apprenticeship/apprenticeship_service.dart';
import '../../models/apprenticeship/apprenticeship_detail_model.dart';
import '../../config/dio_client.dart';
import '../../config/api_config.dart';

class ApprenticeshipUpdate extends StatefulWidget {
  final int apprenticeshipId;

  const ApprenticeshipUpdate({super.key, required this.apprenticeshipId});

  @override
  State<ApprenticeshipUpdate> createState() => _ApprenticeshipUpdateState();
}

class _ApprenticeshipUpdateState extends State<ApprenticeshipUpdate> {
  final _formKey = GlobalKey<FormState>();

  late final ApprenticeshipService _service;

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final applicationLinkController = TextEditingController();
  final expiredAtController = TextEditingController();

  File? _image;
  String? _existingImage;

  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _service = ApprenticeshipService(DioClient.instance);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await _service.getApprenticeshipDetail(
        widget.apprenticeshipId,
      );

      if (!mounted) return;

      _fillForm(data);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Gagal memuat data');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _fillForm(ApprenticeshipDetail data) {
    titleController.text = data.title;
    companyController.text = data.companyName;
    locationController.text = data.location;
    descriptionController.text = data.description;
    applicationLinkController.text = data.applicationLink ?? '';
    expiredAtController.text = data.expiredAt != null
        ? data.expiredAt!.toIso8601String().split('T').first
        : '';

    _existingImage = data.image; // ← pastikan model punya field image
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Widget _imageSection() {
    ImageProvider? imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (_existingImage != null) {
      imageProvider = NetworkImage(
        '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/$_existingImage',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Gambar',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade200,
            ),
            child: imageProvider != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image(image: imageProvider, fit: BoxFit.contain),
                  )
                : SizedBox(
                    height: 160,
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 8),

        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Pilih Gambar'),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _selectDate() async {
    final initialDate = expiredAtController.text.isNotEmpty
        ? DateTime.tryParse(expiredAtController.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      expiredAtController.text = picked.toIso8601String().split('T').first;
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final message = await _service.updateApprenticeship(
        id: widget.apprenticeshipId,
        data: {
          "title": titleController.text.trim(),
          "company_name": companyController.text.trim(),
          "location": locationController.text.trim(),
          "description": descriptionController.text.trim(),
          "application_link": applicationLinkController.text.trim(),
          "expired_at": expiredAtController.text.isEmpty
              ? null
              : expiredAtController.text,
        },
        image: _image, // ← kirim image jika ada
      );

      if (!mounted) return;

      _showSnackBar(message);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    applicationLinkController.dispose();
    expiredAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: const AppHeader(title: 'Update Info Magang', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _imageSection(),

                      AppInput(
                        label: 'Judul Magang',
                        hint: 'Masukkan judul magang',
                        controller: titleController,
                        icon: Icons.work_outline,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Nama Perusahaan',
                        hint: 'Masukkan nama perusahaan',
                        controller: companyController,
                        icon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Lokasi',
                        hint: 'Masukkan lokasi',
                        controller: locationController,
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Deskripsi Magang',
                        hint: 'Tuliskan deskripsi magang',
                        controller: descriptionController,
                        icon: Icons.description_outlined,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Link Pendaftaran',
                        hint: 'Masukkan link apply / WhatsApp / website',
                        controller: applicationLinkController,
                        icon: Icons.link_outlined,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Tanggal Berakhir (Opsional)',
                        hint: 'Pilih tanggal',
                        controller: expiredAtController,
                        icon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: _selectDate,
                        validator: (_) => null,
                      ),
                      const SizedBox(height: 28),

                      AppButton(
                        label: 'Update & Ajukan Ulang',
                        icon: Icons.refresh,
                        isLoading: _isSubmitting,
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
