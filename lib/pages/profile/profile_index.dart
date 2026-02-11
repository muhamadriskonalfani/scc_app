import 'package:flutter/material.dart';
import '../../services/profile/profile_service.dart';
import '../../services/auth_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';
import '../../config/api_config.dart';

class ProfileIndex extends StatefulWidget {
  const ProfileIndex({super.key});

  @override
  State<ProfileIndex> createState() => _ProfileIndexState();
}

class _ProfileIndexState extends State<ProfileIndex> {
  final _profileService = ProfileService();
  final _authService = AuthService();

  late Future<ProfileResponse> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.getProfile();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      appBar: AppHeader(
        title: 'Profil',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 4),

      body: FutureBuilder<ProfileResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.success != true) {
            return const Center(child: Text('Gagal memuat profil'));
          }

          final profile = snapshot.data!.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            child: profile == null
                ? _buildEmptyProfile()
                : _buildProfile(profile),
          );
        },
      ),
    );
  }

  /// =============================
  /// PROFILE KOSONG
  /// =============================
  Widget _buildEmptyProfile() {
    return _card(
      child: Column(
        children: [
          const Icon(Icons.person_outline, size: 56, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            'Profil belum dibuat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Lengkapi profil agar lebih dikenal',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _primaryButton(
            label: 'Buat Profil',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.profileCreate),
          ),
          const SizedBox(height: 16),
          _logoutButton(),
        ],
      ),
    );
  }

  /// =============================
  /// PROFILE ADA
  /// =============================
  Widget _buildProfile(ProfileData profile) {
    final avatar = profile.image != null
        ? NetworkImage('${ApiConfig.baseUrl}/storage/${profile.image}')
        : AssetImage(
                profile.gender == 'female'
                    ? 'assets/images/profile_female.png'
                    : 'assets/images/profile_male.png',
              )
              as ImageProvider;

    return Column(
      children: [
        _card(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.profileUpdate),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ),

              CircleAvatar(radius: 56, backgroundImage: avatar),
              const SizedBox(height: 12),

              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.nim ?? '-',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              _section('Data Akademik', [
                _info('Email', profile.email),
                _info('NIM', profile.nim),
                _info('Fakultas', profile.faculty),
                _info('Program Studi', profile.studyProgram),
                _info('Angkatan', profile.entryYear?.toString()),
              ]),

              _section('Informasi Pribadi', [
                _info('No. Telepon', profile.phone),
                _info('Bio', profile.bio),
                _info('Testimoni', profile.testimonial),
              ]),

              _section('Karier', [
                _info('Pendidikan', profile.education),
                _info('Keahlian', profile.skills),
                _info('Pengalaman', profile.experience),
                _info('LinkedIn', profile.linkedinUrl),
              ]),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _primaryButton(
          label: 'Info Karir Saya',
          icon: Icons.work_outline,
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.profileCareerInfo),
        ),

        const SizedBox(height: 16),
        _logoutButton(),
      ],
    );
  }

  /// =============================
  /// KOMPONEN BANTU
  /// =============================
  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 5,
            child: Text(value?.isNotEmpty == true ? value! : '-'),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: icon != null ? Icon(icon) : const SizedBox(),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _logoutButton() {
    return OutlinedButton(
      onPressed: _logout,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('Logout'),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
