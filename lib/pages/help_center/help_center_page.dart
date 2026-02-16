import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const Color _primaryBlue = Color(0xFF2563EB);

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Tidak dapat membuka link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: const AppHeader(title: 'Bantuan', showBack: false),
      bottomNavigationBar: const AppBottomBar(currentIndex: 5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          children: [
            _headerSection(),
            const SizedBox(height: 20),
            _contactCard(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: const [
          Icon(Icons.help_outline, size: 40, color: _primaryBlue),
          SizedBox(height: 12),
          Text(
            "Pusat Bantuan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff111827),
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Silakan hubungi kami jika mengalami kendala.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xff6b7280)),
          ),
        ],
      ),
    );
  }

  // ================= CONTACT CARD =================

  Widget _contactCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kontak Resmi",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 16),

          _contactTile(
            icon: Icons.phone_outlined,
            label: "Telepon",
            value: "(021) 12345678",
            onTap: () => _launch("tel:02112345678"),
          ),

          const Divider(height: 24),

          _contactTile(
            icon: Icons.chat_bubble_outline,
            label: "WhatsApp",
            value: "0812-3456-7890",
            onTap: () => _launch("https://wa.me/6281234567890"),
          ),

          const Divider(height: 24),

          _contactTile(
            icon: Icons.email_outlined,
            label: "Email",
            value: "support@kampus.ac.id",
            onTap: () => _launch("mailto:support@kampus.ac.id"),
          ),
        ],
      ),
    );
  }

  // ================= CONTACT TILE =================

  Widget _contactTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _primaryBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff6b7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff111827),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_outlined,
              size: 18,
              color: Color(0xff9ca3af),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD DECORATION =================

  BoxDecoration _cardDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}
