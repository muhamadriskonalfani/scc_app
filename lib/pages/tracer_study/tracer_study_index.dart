import 'package:flutter/material.dart';
import '../../services/tracer_study/tracer_study_service.dart';
import '../../models/tracer_study/tracer_study_model.dart';
import '../../config/dio_client.dart';
import '../../config/api_config.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_button.dart';

class TracerStudyIndex extends StatefulWidget {
  const TracerStudyIndex({super.key});

  @override
  State<TracerStudyIndex> createState() => _TracerStudyIndexState();
}

class _TracerStudyIndexState extends State<TracerStudyIndex> {
  late final TracerStudyService _service;
  late Future<TracerStudyModel?> _future;

  @override
  void initState() {
    super.initState();
    _service = TracerStudyService(DioClient.instance);
    _future = _service.getTracerStudy();
  }

  void _refresh() {
    setState(() {
      _future = _service.getTracerStudy();
    });
  }

  void _goToUpdate(TracerStudyModel tracerStudy) {
    Navigator.pushNamed(
      context,
      AppRoutes.tracerStudyUpdate,
      arguments: tracerStudy,
    ).then((updated) {
      if (updated == true) {
        _refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppHeader(title: 'Tracer Study', showBack: false),
      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: FutureBuilder<TracerStudyModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Terjadi kesalahan saat mengambil data'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Data tracer study belum tersedia'),
            );
          }

          return _content(snapshot.data!);
        },
      ),
    );
  }

  Widget _content(TracerStudyModel data) {
    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          children: [
            _profileCard(data),
            const SizedBox(height: 20),
            _sectionCard(
              title: "Data Pribadi",
              children: [
                _infoTile("Nama", data.name),
                _infoTile("NIM", data.nim),
                _infoTile("Domisili", data.domicile),
                _infoTile("No. HP", data.phone),
                _infoTile("Gender", data.gender),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Informasi Akademik",
              children: [
                _infoTile("Fakultas", data.faculty),
                _infoTile("Program Studi", data.studyProgram),
                _infoTile("Tahun Masuk", data.entryYear?.toString()),
                _infoTile("Tahun Lulus", data.graduationYear?.toString()),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Informasi Pekerjaan",
              children: [
                _infoTile("Status Pekerjaan", data.employmentStatus),
                _infoTile("Tempat Kerja", data.currentWorkplace),
                _infoTile("Skala Perusahaan", data.companyScale),
                _infoTile("Jabatan", data.jobTitle),
                _infoTile("Kategori Pekerjaan", data.jobCategory),
                _infoTile("Jenis Pekerjaan", data.employmentType),
                _infoTile("Sektor Pekerjaan", data.employmentSector),
                _infoTile("Rentang Gaji", data.monthlyIncomeRange),
                _infoTile("Relevansi Studi", data.jobStudyRelevanceLevel),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Masukan untuk Universitas",
              children: [_infoTile("Saran", data.suggestionForUniversity)],
            ),
            const SizedBox(height: 28),
            AppButton(
              label: "Lengkapi / Perbarui Data",
              icon: Icons.edit_outlined,
              onPressed: () => _goToUpdate(data),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================

  Widget _profileCard(TracerStudyModel profile) {
    ImageProvider avatar;

    if (profile.image != null && profile.image!.isNotEmpty) {
      final imageUrl =
          '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${profile.image}';
      avatar = NetworkImage(imageUrl);
    } else {
      avatar = AssetImage(
        profile.gender?.toLowerCase() == 'female'
            ? 'assets/images/profile_female.png'
            : 'assets/images/profile_male.png',
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xffe5e7eb),
            backgroundImage: avatar,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? "-",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  profile.nim ?? "-",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff6b7280),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0EDFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.gender ?? "-",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION CARD =================

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ================= INFO TILE =================

  Widget _infoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xff6b7280)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xff111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
