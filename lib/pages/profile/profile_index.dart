import 'package:flutter/material.dart';
import '../../services/profile/profile_service.dart';
import '../../services/auth_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_button.dart';
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
    _loadProfile();
  }

  void _loadProfile() {
    _profileFuture = _profileService.getProfile();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadProfile();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<ProfileResponse>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data;

            if (data == null) {
              return const Center(child: Text('Terjadi kesalahan'));
            }

            if (data.profile == null) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                children: [_buildEmptyProfile()],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              children: [_buildProfile(data.profile!)],
            );
          },
        ),
      ),
    );
  }

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
          const SizedBox(height: 24),
          AppButton(
            label: 'Buat Profil',
            icon: Icons.person_add_alt_1_outlined,
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.profileCreate);
              _refresh();
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Logout',
            type: AppButtonType.secondary,
            onPressed: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(ProfileData profile) {
    ImageProvider avatar;

    if (profile.image != null && profile.image!.isNotEmpty) {
      final imageUrl =
          '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${profile.image}';
      avatar = NetworkImage(imageUrl);
    } else {
      avatar = AssetImage(
        profile.gender == 'female'
            ? 'assets/images/profile_female.png'
            : 'assets/images/profile_male.png',
      );
    }

    return Column(
      children: [
        _card(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, AppRoutes.profileUpdate);
                    _refresh();
                  },
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

              _section('Informasi Pribadi', [
                _infoRow('Nama', profile.name),
                _infoRow('Email', profile.email),
                _infoRow('Gender', profile.gender),
                _infoRow('No. Telepon', profile.phone),
                _infoRow('Domisili', profile.domicile),
                _infoRow('Bio', profile.bio),
              ]),

              _section('Data Akademik', [
                _infoRow('Status', profile.role),
                _infoRow('NIM', profile.nim),
                _infoRow('Fakultas', profile.faculty),
                _infoRow('Program Studi', profile.studyProgram),
                _infoRow('Angkatan', profile.entryYear?.toString()),
                _infoRow('Testimoni', profile.testimonial),
              ]),

              _section('Karier', [
                _infoRow('Pendidikan', profile.education),
                _infoRow('Keahlian', profile.skills),
                _infoRow('Pengalaman', profile.experience),
                _infoRow('LinkedIn', profile.linkedinUrl),
                _infoRow('Status', profile.employmentStatus),
                _infoRow('Tipe Pekerja', profile.employmentType),
                _infoRow('Nama Perusahaan', profile.currentWorkplace),
                _infoRow('Jabatan', profile.jobTitle),
                _infoRow('Kategori', profile.jobCategory),
              ]),
            ],
          ),
        ),

        const SizedBox(height: 20),

        AppButton(
          label: 'Info Karir Saya',
          icon: Icons.work_outline,
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.profileCareerInfo),
        ),

        const SizedBox(height: 16),

        AppButton(
          label: 'Logout',
          type: AppButtonType.secondary,
          onPressed: _logout,
        ),
      ],
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    final displayValue = (value != null && value.isNotEmpty) ? value : '-';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  displayValue,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 0.6, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
