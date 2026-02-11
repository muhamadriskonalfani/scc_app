import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class ApprenticeshipMy extends StatelessWidget {
  const ApprenticeshipMy({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (nanti ganti dari API)
    final List<Map<String, dynamic>> apprenticeships = [
      {
        'id': 1,
        'title': 'Magang Frontend Developer',
        'company_name': 'PT Teknologi Nusantara',
        'location': 'Jakarta',
        'created_at': '12 Jan 2026',
        'status': 'approved',
        'image': null,
      },
      {
        'id': 2,
        'title': 'Magang Backend Laravel',
        'company_name': 'CV Solusi Digital',
        'location': 'Bandung',
        'created_at': '03 Jan 2026',
        'status': 'pending',
        'image': null,
      },
    ];

    return Scaffold(
      appBar: AppHeader(
        title: 'Magang Saya',
        showBack: true,
        actionIcon: Icons.add,
        onActionPressed: () {
          Navigator.pushNamed(context, AppRoutes.apprenticeshipCreate);
        },
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: apprenticeships.isEmpty
            ? const Center(
                child: Text(
                  'Anda belum memiliki data magang.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: apprenticeships.length,
                itemBuilder: (context, index) {
                  final item = apprenticeships[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'] ?? 'assets/images/logo.png',
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
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['location'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Dibuat ${item['created_at']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _StatusBadge(status: item['status']),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.apprenticeshipDetail,
                                              arguments: item['id'],
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.apprenticeshipUpdate,
                                              arguments: item['id'],
                                            );
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
                },
              ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get color {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
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
        color: color,
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
