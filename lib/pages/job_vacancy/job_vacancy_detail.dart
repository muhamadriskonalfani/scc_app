import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/dio_client.dart';
import '../../models/job_vacancy/job_vacancy_detail_model.dart';
import '../../services/job_vacancy/job_vacancy_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class JobVacancyDetailPage extends StatefulWidget {
  final int jobVacancyId;

  const JobVacancyDetailPage({super.key, required this.jobVacancyId});

  @override
  State<JobVacancyDetailPage> createState() => _JobVacancyDetailPageState();
}

class _JobVacancyDetailPageState extends State<JobVacancyDetailPage> {
  final JobVacancyService _service = JobVacancyService(DioClient.instance);

  JobVacancyDetail? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final result = await _service.getJobVacancyDetail(widget.jobVacancyId);

      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openApplicationLink(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Detail Lowongan',
        showBack: true,
        onBack: () => Navigator.pop(context),
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_data == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    final createdDate = DateFormat('dd MMM yyyy').format(_data!.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageSection(),
          const SizedBox(height: 16),
          _mainCard(createdDate),
          const SizedBox(height: 16),
          _descriptionCard(),
          const SizedBox(height: 16),
          _applicationLinkSection(),
        ],
      ),
    );
  }

  Widget _imageSection() {
    final imageUrl = _data!.image;

    if (imageUrl == null) {
      return _placeholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        '${DioClient.instance.options.baseUrl.replaceAll('/api', '')}/storage/$imageUrl',
        width: double.infinity,
        fit: BoxFit.contain, // ← penting
        errorBuilder: (_, __, ___) => _placeholderImage(),
      ),
    );
  }

  Widget _mainCard(String createdDate) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _data!.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _data!.companyName,
            style: const TextStyle(fontSize: 14, color: Color(0xff6b7280)),
          ),
          const SizedBox(height: 14),

          _metaRow(Icons.location_on_outlined, _data!.location),

          // if (_data!.salary != null)
          //   _metaRow(Icons.payments_outlined, _data!.salary!),
          _metaRow(Icons.access_time_outlined, 'Dipublikasikan $createdDate'),

          if (_data!.creator != null)
            _metaRow(Icons.person_outline, 'Oleh ${_data!.creator!.name}'),

          if (_data!.expiredAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xfffff3cd),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Berlaku sampai ${DateFormat('dd MMM yyyy').format(_data!.expiredAt!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff856404),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _descriptionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, size: 18),
              SizedBox(width: 6),
              Text(
                'Deskripsi Pekerjaan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _data!.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xff374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applicationLinkSection() {
    if (_data!.applicationLink == null || _data!.applicationLink!.isEmpty) {
      return const SizedBox();
    }

    final link = _data!.applicationLink!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.link_outlined, size: 18),
              SizedBox(width: 6),
              Text(
                'Link Pendaftaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Clickable Link Text
          InkWell(
            onTap: () => _openApplicationLink(link),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  link,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff2563eb),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xff9ca3af)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xff6b7280)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: 220,
      color: const Color(0xffe5e7eb),
      child: const Icon(
        Icons.assignment_outlined,
        size: 50,
        color: Color(0xff9ca3af),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.05),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}
