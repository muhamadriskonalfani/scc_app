import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../services/profile/profile_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
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
  final _testimonialCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();

  File? _image;
  File? _cvFile;
  ProfileData? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final response = await _service.getProfile();
    final data = response.profile;

    if (data != null) {
      _profile = data;
      _phoneCtrl.text = data.phone ?? '';
      _testimonialCtrl.text = data.testimonial ?? '';
      _bioCtrl.text = data.bio ?? '';
      _educationCtrl.text = data.education ?? '';
      _skillsCtrl.text = data.skills ?? '';
      _experienceCtrl.text = data.experience ?? '';
      _linkedinCtrl.text = data.linkedinUrl ?? '';
    }

    setState(() => _loading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _service.updateProfile(
        phone: _phoneCtrl.text,
        testimonial: _testimonialCtrl.text,
        bio: _bioCtrl.text,
        education: _educationCtrl.text,
        skills: _skillsCtrl.text,
        experience: _experienceCtrl.text,
        linkedinUrl: _linkedinCtrl.text,
        image: _image,
        cvFile: _cvFile,
      );

      if (mounted) Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal update profil')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
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
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _card(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _avatarSection(),
                _input(_phoneCtrl, 'No. HP'),
                _input(_linkedinCtrl, 'LinkedIn URL'),
                _textarea(_bioCtrl, 'Bio'),
                _textarea(_testimonialCtrl, 'Testimonial'),
                _textarea(_educationCtrl, 'Pendidikan'),
                _textarea(_skillsCtrl, 'Keahlian'),
                _textarea(_experienceCtrl, 'Pengalaman'),
                const SizedBox(height: 12),
                _cvSection(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: _button(),
                  child: const Text('Update Profil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarSection() {
    ImageProvider imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (_profile?.image != null) {
      imageProvider = NetworkImage(
        '${ApiConfig.baseUrl}/storage/${_profile!.image}',
      );
    } else {
      imageProvider = const AssetImage('assets/images/profile_male.png');
    }

    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: imageProvider),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Ganti Foto'),
        ),
      ],
    );
  }

  Widget _cvSection() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _cvFile != null
                ? _cvFile!.path.split('/').last
                : (_profile?.cvFile ?? 'Belum ada CV'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton.icon(
          onPressed: _pickCV,
          icon: const Icon(Icons.upload_file),
          label: const Text('Ganti CV'),
        ),
      ],
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _textarea(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  ButtonStyle _button() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
