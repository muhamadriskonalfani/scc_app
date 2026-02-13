import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../services/profile/profile_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';
import '../../routes/app_routes.dart';
import '../../config/api_config.dart';

class ProfileUpdateIndex extends StatefulWidget {
  const ProfileUpdateIndex({super.key});

  @override
  State<ProfileUpdateIndex> createState() => _ProfileUpdateIndexState();
}

class _ProfileUpdateIndexState extends State<ProfileUpdateIndex> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfileService();

  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _testimonialCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();

  File? _image;
  File? _cvFile;

  ProfileData? _profile;
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _educationCtrl.dispose();
    _skillsCtrl.dispose();
    _experienceCtrl.dispose();
    _testimonialCtrl.dispose();
    _linkedinCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _service.getProfile();
      final data = response.profile;

      if (data != null) {
        _profile = data;

        _phoneCtrl.text = data.phone ?? '';
        _bioCtrl.text = data.bio ?? '';
        _educationCtrl.text = data.education ?? '';
        _skillsCtrl.text = data.skills ?? '';
        _experienceCtrl.text = data.experience ?? '';
        _testimonialCtrl.text = data.testimonial ?? '';
        _linkedinCtrl.text = data.linkedinUrl ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memuat data profil')));
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _cvFile = File(result.files.single.path!));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      await _service.updateProfile(
        phone: _phoneCtrl.text,
        bio: _bioCtrl.text,
        education: _educationCtrl.text,
        skills: _skillsCtrl.text,
        experience: _experienceCtrl.text,
        testimonial: _testimonialCtrl.text,
        linkedinUrl: _linkedinCtrl.text,
        image: _image,
        cvFile: _cvFile,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil')));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Edit Profil',
        onBack: () => Navigator.pop(context),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _photoSection(),

                AppInput(
                  label: 'No. Telepon',
                  hint: 'Masukkan nomor telepon',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Bio',
                  hint: 'Ceritakan tentang diri Anda',
                  controller: _bioCtrl,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Pendidikan',
                  hint: 'Riwayat pendidikan',
                  controller: _educationCtrl,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Keahlian',
                  hint: 'Contoh: UI Design, Laravel, Flutter',
                  controller: _skillsCtrl,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Pengalaman',
                  hint: 'Pengalaman kerja / organisasi',
                  controller: _experienceCtrl,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Testimoni',
                  hint: 'Testimoni atau kesan',
                  controller: _testimonialCtrl,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'LinkedIn URL',
                  hint: 'https://linkedin.com/in/username',
                  controller: _linkedinCtrl,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),

                _cvField(),

                const SizedBox(height: 24),

                AppButton(
                  label: 'Perbarui Profil',
                  icon: Icons.save_outlined,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoSection() {
    ImageProvider? imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (_profile?.image != null) {
      imageProvider = NetworkImage(
        '${ApiConfig.baseUrl}/storage/${_profile!.image}',
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.person_outline, size: 40)
              : null,
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Ganti Foto Profil'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _cvField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload CV (PDF)',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickCV,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                const Icon(Icons.upload_file_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _cvFile != null
                        ? _cvFile!.path.split('/').last
                        : (_profile?.cvFile ?? 'Pilih File'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
