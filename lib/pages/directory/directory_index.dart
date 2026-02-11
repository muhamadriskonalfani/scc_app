import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../config/dio_client.dart';
import '../../services/directory/directory_service.dart';
import '../../models/directory/directory_user_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class DirectoryIndex extends StatefulWidget {
  const DirectoryIndex({super.key});

  @override
  State<DirectoryIndex> createState() => _DirectoryIndexState();
}

class _DirectoryIndexState extends State<DirectoryIndex> {
  late DirectoryService _service;

  bool _isLoading = true;
  List<DirectoryUserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _service = DirectoryService(DioClient.instance);
    _fetchDirectory();
  }

  Future<void> _fetchDirectory() async {
    setState(() => _isLoading = true);

    try {
      final result = await _service.getDirectory();
      _users = result.users;
    } catch (e) {
      // nanti bisa pakai snackbar / dialog
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _statusLabel(String status) {
    return status == 'student' ? 'Mahasiswa' : 'Alumni';
  }

  String _profileImage(String? gender) {
    if (gender == 'female') {
      return 'assets/images/profile_female.png';
    }
    return 'assets/images/profile_male.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Direktori Kampus',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),

      /// CONTENT
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
              child: Text(
                'Data tidak ditemukan',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.directoryDetail,
                      arguments: user.id,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        /// PHOTO
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            _profileImage(user.gender),
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${user.studyProgram ?? '-'} · Angkatan ${user.entryYear ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),

                              /// STATUS
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _statusLabel(user.status),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      /// BOTTOM BAR
      bottomNavigationBar: const AppBottomBar(currentIndex: 0),
    );
  }
}
