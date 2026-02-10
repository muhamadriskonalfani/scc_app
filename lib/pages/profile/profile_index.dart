import 'package:flutter/material.dart';
import '../../services/profile_service.dart';
import '../../services/auth_service.dart';
import '../../models/profile_response_model.dart';
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

      /// HEADER
      appBar: AppHeader(
        title: 'Profil',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
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
                : _buildProfileCard(profile),
          );
        },
      ),
    );
  }

  /// =============================
  /// PROFILE BELUM ADA
  /// =============================
  Widget _buildEmptyProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Icon(Icons.person_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            'Profil belum dibuat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Lengkapi profil Anda agar lebih dikenal',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.profileCreate),
            style: _primaryButtonStyle(),
            child: const Text('Buat Profil'),
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
  Widget _buildProfileCard(ProfileData profile) {
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
        Container(
          decoration: _cardDecoration(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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
              CircleAvatar(radius: 55, backgroundImage: avatar),
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
              const SizedBox(height: 16),
              _infoItem('Email', profile.email),
              _infoItem('NIM', profile.nim ?? '-'),
              _infoItem('Fakultas', profile.faculty ?? '-'),
              _infoItem('Program Studi', profile.studyProgram ?? '-'),
              _infoItem('Angkatan', profile.entryYear ?? '-'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.profileCareerInfo),
          style: _primaryButtonStyle(),
          icon: const Icon(Icons.work_outline),
          label: const Text('Info Karir Saya'),
        ),
        const SizedBox(height: 16),
        _logoutButton(),
      ],
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo.shade700,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('Logout'),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
