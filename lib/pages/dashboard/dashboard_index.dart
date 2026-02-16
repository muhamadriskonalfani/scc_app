import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/dashboard_service.dart';
import '../../models/dashboard_response_model.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';
import '../../config/api_config.dart';

class DashboardIndex extends StatefulWidget {
  const DashboardIndex({super.key});

  @override
  _DashboardIndexState createState() => _DashboardIndexState();
}

class _DashboardIndexState extends State<DashboardIndex> {
  DateTime? lastPressed; // Untuk double tap back

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return false; // Jangan keluar aplikasi
        }
        return true; // Keluar aplikasi
      },
      child: Scaffold(
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
      ),
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

    if (user.photo != null && user.photo!.isNotEmpty) {
      final imageUrl =
          '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${user.photo}';

      avatar = NetworkImage(imageUrl);
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
          // Stack(
          //   children: const [
          //     Icon(Icons.notifications_none),
          //     Positioned(
          //       right: 0,
          //       top: 0,
          //       child: CircleAvatar(
          //         radius: 9,
          //         backgroundColor: Colors.red,
          //         child: Text(
          //           '3',
          //           style: TextStyle(fontSize: 11, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
      _QuickMenu(Icons.help_outline, 'Bantuan', AppRoutes.helpCenter),
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
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Info Kampus',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.campus);
                },
                child: const Text(
                  'Lihat semua >',
                  style: TextStyle(
                    color: Color(0xff3578c3),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// LIST
          ...list.map((info) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.campusDetail,
                  arguments: info.id,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// IMAGE
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: info.image != null && info.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                info.image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),

                    const SizedBox(width: 14),

                    /// CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            info.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                info.createdAt,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
