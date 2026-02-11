import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../services/profile/profile_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
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

  /// Controllers (HANYA FIELD TABEL PROFILE)
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

  /// ===========================
  /// LOAD PROFILE
  /// ===========================
  Future<void> _loadProfile() async {
    try {
      final response = await _service.getProfile();
      final data = response.profile;

      if (data != null) {
        _profile = data;

        /// Isi hanya dari tabel profile
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

  /// ===========================
  /// PICK IMAGE
  /// ===========================
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  /// ===========================
  /// PICK CV
  /// ===========================
  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _cvFile = File(result.files.single.path!));
    }
  }

  /// ===========================
  /// SUBMIT (UPDATE PROFILE SAJA)
  /// ===========================
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

  /// ===========================
  /// BUILD
  /// ===========================
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
        child: _buildFormCard(),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _photoSection(),
            _inputField('No. Telepon', _phoneCtrl),
            _textareaField('Bio', _bioCtrl, 3),
            _textareaField('Pendidikan', _educationCtrl, 2),
            _textareaField('Keahlian', _skillsCtrl, 2),
            _textareaField('Pengalaman', _experienceCtrl, 3),
            _textareaField('Testimoni', _testimonialCtrl, 3),
            _inputField(
              'LinkedIn URL',
              _linkedinCtrl,
              keyboardType: TextInputType.url,
            ),
            _cvField(),
            const SizedBox(height: 16),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  /// ===========================
  /// FOTO
  /// ===========================
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
        const SizedBox(height: 10),
        _fileButton(
          label: 'Ganti Foto Profil',
          icon: Icons.image_outlined,
          onTap: _pickImage,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _cvField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Upload CV (PDF)'),
        const SizedBox(height: 6),
        _fileButton(
          label: _cvFile != null
              ? _cvFile!.path.split('/').last
              : (_profile?.cvFile ?? 'Pilih File'),
          icon: Icons.upload_file_outlined,
          onTap: _pickCV,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  /// ===========================
  /// INPUT
  /// ===========================
  Widget _inputField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _textareaField(
    String label,
    TextEditingController controller,
    int rows,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          TextFormField(
            controller: controller,
            maxLines: rows,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _fileButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _submitting ? null : _submit,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: _submitting
                  ? const LinearGradient(
                      colors: [Color(0xFF93C5FD), Color(0xFFBFDBFE)],
                    )
                  : const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Perbarui Profil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// ===========================
  /// STYLE
  /// ===========================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff2563eb)),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
