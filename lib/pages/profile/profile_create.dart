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

    if (result != null) {
      setState(() => _cvFile = File(result.files.single.path!));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

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

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profile,
          (_) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _fileButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoSection() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? const Icon(Icons.person_outline, size: 42)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        _fileButton(
          label: 'Pilih Foto Profil',
          icon: Icons.image_outlined,
          onTap: _pickImage,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

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

                AppInput(
                  label: 'No. Telepon',
                  hint: 'Masukkan nomor telepon',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                AppInput(
                  label: 'Domisili',
                  hint: 'Masukan nama tempat tinggal',
                  controller: _domicileCtrl,
                  maxLines: 3,
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
                  hint: 'Contoh: UI Design, Public Speaking',
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
                  hint: 'Testimoni atau pencapaian',
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

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Upload CV (PDF)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 6),
                _fileButton(
                  label: _cvFile == null
                      ? 'Pilih File'
                      : _cvFile!.path.split('/').last,
                  icon: Icons.upload_file_outlined,
                  onTap: _pickCV,
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Upload Tanda Alumni',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 6),
                _fileButton(
                  label: _alumniTag == null
                      ? 'Pilih Gambar'
                      : _alumniTag!.path.split('/').last,
                  icon: Icons.verified_outlined,
                  onTap: _pickAlumniTag,
                ),

                const SizedBox(height: 24),

                AppButton(
                  label: 'Simpan Profil',
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
