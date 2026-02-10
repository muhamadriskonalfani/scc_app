import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomBar({super.key, required this.currentIndex});

  static const _items = [
    _BottomNavItem(
      label: 'Beranda',
      icon: Icons.home_outlined,
      route: AppRoutes.dashboard,
    ),
    _BottomNavItem(
      label: 'Tracer',
      icon: Icons.insights_outlined,
      route: AppRoutes.tracerStudy,
    ),
    _BottomNavItem(
      label: 'Karir',
      icon: Icons.work_outline,
      route: AppRoutes.dashboardCareerInfo,
    ),
    _BottomNavItem(
      label: 'Kampus',
      icon: Icons.school_outlined,
      route: AppRoutes.campus,
    ),
    _BottomNavItem(
      label: 'Akun',
      icon: Icons.person_outline,
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffe5e7eb))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = index == currentIndex;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isActive) {
                Navigator.pushReplacementNamed(context, item.route);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 26, // icon diperbesar
                  color: isActive
                      ? const Color(0xff3578c3)
                      : const Color(0xff9ca3af),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive
                        ? const Color(0xff3578c3)
                        : const Color(0xff6b7280),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavItem {
  final String label;
  final IconData icon;
  final String route;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
