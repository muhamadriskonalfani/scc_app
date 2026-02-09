import 'package:flutter/material.dart';
import '../../services/dashboard_service.dart';
import '../../models/dashboard_response_model.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class DashboardIndex extends StatelessWidget {
  const DashboardIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: FutureBuilder<DashboardResponse>(
          future: DashboardService().fetchDashboard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Gagal memuat dashboard'));
            }

            final data = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _hero(),
                  _userCard(data.user),
                  _quickMenu(context),
                  _campusInfoSection(context, data.campusInfo),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 0),
    );
  }

  // ================= HERO =================
  Widget _hero() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(image: AssetImage('assets/images/logo.png'), width: 64),
            SizedBox(height: 12),
            Text('Selamat Datang di'),
            SizedBox(height: 4),
            Text(
              'Student Career Center',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              'Pusat Karier Mahasiswa',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ================= USER CARD =================
  Widget _userCard(DashboardUser user) {
    ImageProvider avatar;

    if (user.photo != null) {
      avatar = NetworkImage(user.photo!);
    } else {
      avatar = AssetImage(
        user.gender == 'female'
            ? 'assets/images/profile_female.png'
            : 'assets/images/profile_male.png',
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(.08)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 22, backgroundImage: avatar),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    user.studentIdNumber ?? '-',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: const [
              Icon(Icons.notifications_none),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.red,
                  child: Text(
                    '3',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= QUICK MENU =================
  Widget _quickMenu(BuildContext context) {
    final menus = [
      _QuickMenu(Icons.person_outline, 'Profil', AppRoutes.profile),
      _QuickMenu(Icons.groups_outlined, 'Pengguna', AppRoutes.directory),
      _QuickMenu(Icons.assignment_outlined, 'Tracer', AppRoutes.tracerStudy),
      _QuickMenu(
        Icons.work_outline,
        'Info Karir',
        AppRoutes.dashboardCareerInfo,
      ),
      _QuickMenu(Icons.menu_book_outlined, 'Info Kampus', AppRoutes.campus),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: menus.map((menu) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 56) / 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.pushNamed(context, menu.route),
              child: Container(
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(.06),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(menu.icon, size: 28, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      menu.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= INFO KAMPUS =================
  Widget _campusInfoSection(BuildContext context, List<CampusInfo> list) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Info Kampus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.campus);
                },
                child: const Text(
                  'Lihat semua >',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...list.map((info) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.06),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: info.image != null
                        ? Image.network(
                            info.image!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/logo.png',
                            width: 72,
                            height: 72,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info.createdAt,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ================= MENU MODEL =================
class _QuickMenu {
  final IconData icon;
  final String label;
  final String route;

  _QuickMenu(this.icon, this.label, this.route);
}
