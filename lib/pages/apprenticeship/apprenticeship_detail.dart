import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class ApprenticeshipDetail extends StatelessWidget {
  final Map<String, dynamic> apprenticeship;

  const ApprenticeshipDetail({super.key, required this.apprenticeship});

  @override
  Widget build(BuildContext context) {
    final image = apprenticeship['image'];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Detail Magang',
        showBack: true,
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.apprenticeship),
      ),

      // FOOTER
      bottomNavigationBar: const AppBottomBar(currentIndex: 1),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: image != null && image.toString().isNotEmpty
                  ? Image.network(
                      image,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 16),

            // MAIN CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apprenticeship['title'] ?? '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    apprenticeship['company_name'] ?? '-',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  _metaItem(
                    Icons.location_on_outlined,
                    apprenticeship['location'] ?? '-',
                  ),
                  _metaItem(
                    Icons.calendar_month_outlined,
                    'Dipublikasikan ${apprenticeship['created_at'] ?? '-'}',
                  ),

                  if (apprenticeship['expired_at'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xfffff3cd),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Berlaku sampai ${apprenticeship['expired_at']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff856404),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DESCRIPTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.description_outlined, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Deskripsi Magang',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    apprenticeship['description'] ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: Color(0xff444444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
