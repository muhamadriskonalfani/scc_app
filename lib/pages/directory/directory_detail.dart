import 'package:flutter/material.dart';
import '../../config/api_config.dart';
import '../../config/dio_client.dart';
import '../../models/directory/directory_detail_model.dart';
import '../../services/directory/directory_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class DirectoryDetail extends StatefulWidget {
  const DirectoryDetail({super.key});

  @override
  State<DirectoryDetail> createState() => _DirectoryDetailState();
}

class _DirectoryDetailState extends State<DirectoryDetail> {
  late Future<DirectoryDetailModel> _future;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is int) {
        _future = DirectoryService(DioClient.instance).getDirectoryDetail(args);
        _initialized = true;
      }
    }
  }

  String _statusLabel(String? status) {
    if (status == 'alumni') return 'Alumni';
    return 'Mahasiswa';
  }

  String _fullPhotoUrl(String? path) {
    if (path == null) return '';
    return '${ApiConfig.baseUrl}/storage/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Detail Profil',
        onBack: () => Navigator.pop(context),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: !_initialized
          ? const Center(child: Text('User tidak ditemukan'))
          : FutureBuilder<DirectoryDetailModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Gagal memuat detail user'));
                }

                final user = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _profileHeader(user),
                      const SizedBox(height: 20),
                      _sectionCard(
                        title: 'Informasi Akademik',
                        children: [
                          _infoRow('Status', _statusLabel(user.status)),
                          _infoRow('Fakultas', user.faculty),
                          _infoRow('Program Studi', user.studyProgram),
                          _infoRow('Angkatan', user.entryYear?.toString()),
                          _infoRow(
                            'Tahun Lulus',
                            user.graduationYear?.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _sectionCard(
                        title: 'Karir',
                        children: [
                          _infoRow('Pekerjaan', user.jobTitle),
                          _infoRow('Instansi', user.currentWorkplace),
                          if (user.skills != null && user.skills!.isNotEmpty)
                            _skillsChips(user.skills!),
                        ],
                      ),
                      if (user.bio != null && user.bio!.trim().isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _sectionCard(
                          title: 'Tentang',
                          children: [
                            Text(
                              user.bio!,
                              style: const TextStyle(height: 1.6),
                            ),
                          ],
                        ),
                      ],
                      if (user.testimonial != null &&
                          user.testimonial!.trim().isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _testimonialCard(user.testimonial!),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }

  // =========================
  // PROFILE HEADER
  // =========================
  Widget _profileHeader(DirectoryDetailModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white,
            backgroundImage: (user.photo != null && user.photo!.isNotEmpty)
                ? NetworkImage(_fullPhotoUrl(user.photo))
                : AssetImage(
                    user.gender == 'female'
                        ? 'assets/images/profile_female.png'
                        : 'assets/images/profile_male.png',
                  ),
          ),

          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusLabel(user.status),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SECTION CARD
  // =========================
  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // =========================
  // INFO ROW
  // =========================
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SKILLS CHIPS
  // =========================
  Widget _skillsChips(String skills) {
    final skillList = skills.split(',').map((e) => e.trim()).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skillList
          .map(
            (skill) =>
                Chip(label: Text(skill), backgroundColor: Colors.blue.shade50),
          )
          .toList(),
    );
  }

  // =========================
  // TESTIMONIAL CARD
  // =========================
  Widget _testimonialCard(String testimonial) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Testimonial',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '"$testimonial"',
            style: const TextStyle(fontStyle: FontStyle.italic, height: 1.6),
          ),
        ],
      ),
    );
  }
}
