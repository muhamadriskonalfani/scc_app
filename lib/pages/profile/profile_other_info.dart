import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/profile/profile_service.dart';
import '../../models/profile/profile_response_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_button.dart';
import '../../config/api_config.dart';

class ProfileOtherInfo extends StatefulWidget {
  const ProfileOtherInfo({super.key});

  @override
  State<ProfileOtherInfo> createState() => _ProfileOtherInfoState();
}

class _ProfileOtherInfoState extends State<ProfileOtherInfo> {
  final _profileService = ProfileService();
  late Future<ProfileResponse> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.getProfile();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Info Lainnya',
        onBack: () => Navigator.pop(context),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 4),
      body: FutureBuilder<ProfileResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data;

          if (data == null || data.profile == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final profile = data.profile!;

          final alumniTagUrl =
              profile.alumniTag != null && profile.alumniTag!.isNotEmpty
              ? '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${profile.alumniTag}'
              : null;

          final cvUrl = profile.cvFile != null && profile.cvFile!.isNotEmpty
              ? '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${profile.cvFile}'
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            children: [
              /// ==============================
              /// SECTION ALUMNI TAG
              /// ==============================
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kartu Alumni',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (alumniTagUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(alumniTagUrl, fit: BoxFit.cover),
                      )
                    else
                      const Text(
                        'Belum mengunggah kartu alumni',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ==============================
              /// SECTION CV
              /// ==============================
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Curriculum Vitae (CV)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (cvUrl != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'File CV tersedia',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: 'Lihat',
                              icon: Icons.visibility_outlined,
                              onPressed: () => _launchUrl(cvUrl),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              label: 'Download',
                              type: AppButtonType.secondary,
                              icon: Icons.download_outlined,
                              onPressed: () => _launchUrl(cvUrl),
                            ),
                          ),
                        ],
                      ),
                    ] else
                      const Text(
                        'Belum mengunggah CV',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ==============================
  /// CARD STYLE (SAMA SEPERTI PROFILE INDEX)
  /// ==============================
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
