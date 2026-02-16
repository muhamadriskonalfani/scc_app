import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../services/profile/profile_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_button.dart';
import '../../routes/app_routes.dart';

class ProfileCreateIndex extends StatefulWidget {
  const ProfileCreateIndex({super.key});

  @override
  State<ProfileCreateIndex> createState() => _ProfileCreateIndexState();
}

class _ProfileCreateIndexState extends State<ProfileCreateIndex> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfileService();

  final _phoneCtrl = TextEditingController();
  final _domicileCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _testimonialCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();

  File? _image;
  File? _cvFile;
  File? _alumniTag;

  bool _submitting = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _domicileCtrl.dispose();
    _bioCtrl.dispose();
    _educationCtrl.dispose();
    _skillsCtrl.dispose();
    _experienceCtrl.dispose();
    _testimonialCtrl.dispose();
    _linkedinCtrl.dispose();
    super.dispose();
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

  Future<void> _pickAlumniTag() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _alumniTag = File(picked.path));
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
      await _service.createProfile(
        phone: _phoneCtrl.text,
        domicile: _domicileCtrl.text,
        bio: _bioCtrl.text,
        education: _educationCtrl.text,
        skills: _skillsCtrl.text,
        experience: _experienceCtrl.text,
        testimonial: _testimonialCtrl.text,
        linkedinUrl: _linkedinCtrl.text,
        image: _image,
        cvFile: _cvFile,
        alumniTag: _alumniTag,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profil berhasil dibuat')));

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.profile,
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _photoSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null
              ? const Icon(Icons.person_outline, size: 40)
              : null,
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Pilih Foto Profil'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _alumniTagSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: _alumniTag != null ? FileImage(_alumniTag!) : null,
          child: _alumniTag == null
              ? const Icon(Icons.verified_outlined, size: 32)
              : null,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _pickAlumniTag,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Pilih Tanda Alumni'),
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
                        : 'Pilih File',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Buat Profil',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.profile),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _photoSection(),
                _alumniTagSection(),

                AppInput(
                  label: 'No. Telepon',
                  hint: 'Masukkan nomor telepon',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Domisili',
                  hint: 'Masukkan domisili saat ini',
                  controller: _domicileCtrl,
                  maxLines: 2,
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
                  hint: 'Contoh: UI Design, Flutter, Laravel',
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
                  label: 'Simpan Profil',
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
}
