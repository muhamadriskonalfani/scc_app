import 'package:flutter/material.dart';
import '../../services/tracer_study/tracer_study_service.dart';
import '../../models/tracer_study/tracer_study_model.dart';
import '../../config/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

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
            return _emptyState();
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileCard(data),
            const SizedBox(height: 20),
            _careerCard(data),
            const SizedBox(height: 24),
            _gradientButton(
              label: 'Lengkapi / Perbarui Data',
              onTap: () => _goToUpdate(data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(TracerStudyModel data) {
    return _card(
      title: 'Informasi Akademik',
      child: Column(
        children: [
          _infoItem('Fakultas', data.faculty?.name),
          _infoItem('Program Studi', data.studyProgram?.name),
          _infoItem('Domisili', data.domicile),
          _infoItem('WhatsApp', data.whatsappNumber),
        ],
      ),
    );
  }

  Widget _careerCard(TracerStudyModel data) {
    return _card(
      title: 'Informasi Karir',
      child: Column(
        children: [
          _infoItem('Tempat Bekerja', data.currentWorkplace),
          _infoItem(
            'Lama Bekerja',
            data.currentJobDurationMonths != null
                ? '${data.currentJobDurationMonths} bulan'
                : null,
          ),
          _infoItem('Skala Perusahaan', data.companyScale),
          _infoItem('Jabatan', data.jobTitle),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Color(0xff9ca3af),
            ),
            const SizedBox(height: 16),
            const Text(
              'Data tracer study belum tersedia',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan lengkapi data tracer study Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _gradientButton(label: 'Lengkapi Sekarang', onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _gradientButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2563EB), // biru utama
              Color(0xFF3B82F6), // biru lebih terang (soft)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Lengkapi / Perbarui Data',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoItem(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
              value ?? '-',
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
}
