import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class JobVacancyIndex extends StatelessWidget {
  const JobVacancyIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      // HEADER
      appBar: const AppHeader(title: 'Info Lowongan', showBack: true),

      // CONTENT
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          children: [
            // ================= FILTER (DIKOMENTAR)
            /*
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Filter Tanggal',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            */

            // ================= LIST
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _jobItem(context);
                },
              ),
            ),
          ],
        ),
      ),

      // FOOTER
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
    );
  }

  Widget _jobItem(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Navigator.pushNamed(context, AppRoutes.jobVacancyDetail);
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
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // BODY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Frontend Developer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'PT Teknologi Nusantara',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 6),

                  _MetaRow(icon: Icons.location_on_outlined, text: 'Jakarta'),
                  SizedBox(height: 4),

                  _MetaRow(icon: Icons.access_time, text: '10 Feb 2026'),

                  SizedBox(height: 4),

                  _MetaRow(
                    icon: Icons.error_outline,
                    text: 'Berakhir 25 Feb 2026',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
