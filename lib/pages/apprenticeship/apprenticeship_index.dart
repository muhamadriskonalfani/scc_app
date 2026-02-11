import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class ApprenticeshipIndex extends StatelessWidget {
  const ApprenticeshipIndex({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (nanti ganti dari API)
    final List<Map<String, dynamic>> apprenticeships = [
      {
        'id': 1,
        'title': 'Magang Frontend Developer',
        'company_name': 'PT Teknologi Nusantara',
        'location': 'Jakarta',
        'image': null,
        'created_at': '2024-01-10',
        'expired_at': '2024-03-01',
      },
      {
        'id': 2,
        'title': 'Magang UI/UX Designer',
        'company_name': 'CV Kreatif Digital',
        'location': 'Bandung',
        'image': null,
        'created_at': '2024-01-05',
        'expired_at': null,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Info Magang',
        showBack: true,
        onBack: () => Navigator.pushReplacementNamed(
          context,
          AppRoutes.dashboardCareerInfo,
        ),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =====================
            // FILTER TANGGAL (OFF)
            // =====================
            /*
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filter Tanggal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            */

            // =====================
            // LIST
            // =====================
            Expanded(
              child: apprenticeships.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada informasi magang.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: apprenticeships.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = apprenticeships[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.apprenticeshipDetail,
                              arguments: item['id'],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // =====================
                                // IMAGE
                                // =====================
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['image'] ?? 'assets/images/logo.png',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // =====================
                                // BODY
                                // =====================
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['company_name'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      _metaRow(
                                        Icons.location_on_outlined,
                                        item['location'],
                                      ),
                                      _metaRow(
                                        Icons.access_time,
                                        item['created_at'],
                                      ),
                                      if (item['expired_at'] != null)
                                        _metaRow(
                                          Icons.error_outline,
                                          'Berakhir ${item['expired_at']}',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
