import 'package:flutter/material.dart';

import '../../config/dio_client.dart';
import '../../models/directory/directory_detail_model.dart';
import '../../services/directory/directory_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class DirectoryDetail extends StatefulWidget {
  const DirectoryDetail({super.key});

  @override
  State<DirectoryDetail> createState() => _DirectoryDetailState();
}

class _DirectoryDetailState extends State<DirectoryDetail> {
  late Future<DirectoryDetailModel> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int userId = ModalRoute.of(context)!.settings.arguments as int;

    _future = DirectoryService(DioClient.instance).getDirectoryDetail(userId);
  }

  String _profileImage(String? gender) {
    if (gender == 'female') {
      return 'assets/images/profile_female.png';
    }
    return 'assets/images/profile_male.png';
  }

  String _statusLabel(String status) {
    if (status == 'alumni') return 'Alumni';
    return 'Mahasiswa';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Detail',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: FutureBuilder<DirectoryDetailModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                // =====================
                // PROFILE HEADER
                // =====================
                Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(_profileImage(user.gender)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(user.status),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =====================
                // DETAIL CARD
                // =====================
                _detailCard([
                  _detailItem('Fakultas', user.faculty),
                  _detailItem('Program Studi', user.studyProgram),
                  _detailItem('Angkatan', user.entryYear?.toString()),
                  _detailItem(
                    'Tahun Lulus',
                    user.graduationYear?.toString() ?? '-',
                  ),
                  _detailItem('Pekerjaan', user.jobTitle ?? '-'),
                  _detailItem('Instansi', user.currentWorkplace ?? '-'),
                ]),

                // =====================
                // BIO
                // =====================
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _detailCard([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bio',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.bio!,
                          style: const TextStyle(fontSize: 13, height: 1.6),
                        ),
                      ],
                    ),
                  ]),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // =====================
  // WIDGETS
  // =====================
  Widget _detailCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _detailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Expanded(
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
