import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/job_vacancy/job_vacancy_detail_model.dart';
import '../../services/job_vacancy/job_vacancy_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../config/dio_client.dart';

class JobVacancyDetailPage extends StatefulWidget {
  final int id;
  const JobVacancyDetailPage({super.key, required this.id});

  @override
  State<JobVacancyDetailPage> createState() => _JobVacancyDetailPageState();
}

class _JobVacancyDetailPageState extends State<JobVacancyDetailPage> {
  late final JobVacancyService _service;
  JobVacancyDetailModel? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = JobVacancyService(DioClient.instance);
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final result = await _service.fetchJobVacancyDetail(widget.id);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = 'Gagal memuat detail lowongan');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Detail Lowongan Kerja'),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    final job = _data!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(job.image),
          const SizedBox(height: 16),
          _buildMainInfo(job),
          const SizedBox(height: 16),
          _buildDescription(job),
          if (job.expiredAt != null) ...[
            const SizedBox(height: 16),
            _buildExpired(job.expiredAt!),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String? image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: image != null && image.isNotEmpty
          ? Image.network(
              image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/images/logo.png',
              height: 220,
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildMainInfo(JobVacancyDetailModel job) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _meta(Icons.business, job.companyName),
          _meta(Icons.location_on, job.location),
          _meta(
            Icons.calendar_today,
            DateFormat('dd MMMM yyyy', 'id').format(job.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(JobVacancyDetailModel job) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Lowongan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(job.description, style: const TextStyle(height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildExpired(DateTime expiredAt) {
    return _card(
      Text(
        'Berlaku sampai ${DateFormat('dd MMMM yyyy', 'id').format(expiredAt)}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: child,
    );
  }
}
