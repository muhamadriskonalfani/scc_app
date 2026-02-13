import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bottom_bar.dart';

class ProfileCareerInfo extends StatelessWidget {
  const ProfileCareerInfo({super.key});

  static const _bgColor = Color(0xfff6f7fb);
  static const _borderColor = Color(0xffe5e7eb);
  static const _blueLight = Color(0xffeaf3ff);
  static const _blue = Color(0xff3578c3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,

      // ================= HEADER =================
      body: Column(
        children: [
          _buildHeader(context),

          // ================= CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _careerItem(
                    context,
                    icon: Icons.work_outline,
                    title: 'Informasi Magang Saya',
                    subtitle: 'Program magang & internship',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.apprenticeshipMy);
                    },
                  ),
                  _careerItem(
                    context,
                    icon: Icons.assignment_outlined,
                    title: 'Lowongan Kerja Saya',
                    subtitle: 'Info karier & rekrutmen',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.jobVacancyMy);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= BOTTOM BAR =================
      bottomNavigationBar: const AppBottomBar(currentIndex: 4),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: _borderColor)),
        ),
        child: Row(
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              onPressed: () => Navigator.pop(context),
            ),

            // Title
            const Expanded(
              child: Text(
                'Pilih Info Karir',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            // Spacer (biar title benar-benar center)
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // ================= CAREER ITEM =================
  Widget _careerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.06)),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _blueLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _blue, size: 22),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
