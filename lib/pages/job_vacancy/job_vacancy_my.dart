import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';

class JobVacancyMy extends StatelessWidget {
  const JobVacancyMy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      // HEADER
      appBar: AppHeader(
        title: 'Lowongan Saya',
        showBack: true,
        actionIcon: Icons.add,
        onActionPressed: () {
          Navigator.pushNamed(context, AppRoutes.jobVacancyCreate);
        },
      ),

      // CONTENT
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return _jobCard(context);
          },
        ),
      ),

      // FOOTER
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
    );
  }

  Widget _jobCard(BuildContext context) {
    final status = 'approved'; // pending | approved | rejected | ended

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/logo.png',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // BODY
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Backend Developer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                const Text(
                  'PT Solusi Digital Indonesia',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 6),

                const _MetaText(
                  icon: Icons.location_on_outlined,
                  text: 'Bandung',
                ),
                const SizedBox(height: 4),
                const _MetaText(
                  icon: Icons.access_time,
                  text: 'Dibuat 10 Feb 2026',
                ),

                // FOOTER
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: status),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              // Navigator.pushNamed(context, AppRoutes.jobVacancyDetail);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {
                              // Navigator.pushNamed(context, AppRoutes.jobVacancyEdit);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({required this.icon, required this.text});

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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'ended':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
