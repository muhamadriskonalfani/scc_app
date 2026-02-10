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

  /// 🔹 Helper untuk navigasi ke halaman update
  void _goToUpdate(TracerStudyModel tracerStudy) {
    Navigator.pushNamed(
      context,
      AppRoutes.tracerStudyUpdate,
      arguments: tracerStudy,
    ).then((updated) {
      // kalau halaman update return true → refresh data
      if (updated == true) {
        setState(() {
          _future = _service.getTracerStudy();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Tracer Study',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 1),

      body: FutureBuilder<TracerStudyModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal mengambil data tracer study'),
            );
          }

          // Belum ada data
          if (!snapshot.hasData || snapshot.data == null) {
            return _emptyState();
          }

          return _content(snapshot.data!);
        },
      ),
    );
  }

  Widget _content(TracerStudyModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _card(
            title: 'Data Tracer Study Anda',
            child: Column(
              children: [
                _infoItem('Domisili', data.domicile),
                _infoItem('WhatsApp', data.whatsappNumber),
                _infoItem('Fakultas', data.faculty?.name),
                _infoItem('Program Studi', data.studyProgram?.name),
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
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => _goToUpdate(data),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Lengkapi / Perbarui Data'),
            ),
          ),
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
            const Text(
              'Tracer study belum diisi',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Kalau belum ada data → biasanya ke halaman create
                // atau backend mengembalikan default model
              },
              child: const Text('Isi Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoItem(String label, String? value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffE5E7EB), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
