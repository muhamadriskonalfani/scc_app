import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/dio_client.dart';
import '../../services/campus/campus_information_service.dart';
import '../../models/campus/campus_information_detail_model.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class CampusDetail extends StatefulWidget {
  const CampusDetail({super.key});

  @override
  State<CampusDetail> createState() => _CampusDetailState();
}

class _CampusDetailState extends State<CampusDetail> {
  late CampusInformationService _service;

  bool _loading = true;
  String? _error;
  CampusInformationDetailModel? _data;

  @override
  void initState() {
    super.initState();
    _service = CampusInformationService(DioClient.instance);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(int id) async {
    try {
      final result = await _service.getInformationDetail(id);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: const AppHeader(title: 'Detail Informasi', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 3),
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
      return const Center(child: Text('Informasi tidak ditemukan'));
    }

    final createdDate = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(_data!.createdAt));

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
        ],
      ),
    );
  }

  Widget _imageSection() {
    final imageUrl = _data!.image;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _placeholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.contain,
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
          const SizedBox(height: 12),

          _metaRow(Icons.access_time_outlined, 'Dipublikasikan $createdDate'),

          if (_data!.createdBy.isNotEmpty)
            _metaRow(Icons.person_outline, 'Oleh ${_data!.createdBy}'),

          if (_data!.faculty.isNotEmpty)
            _metaRow(Icons.school_outlined, 'Fakultas ${_data!.faculty}'),
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
                'Deskripsi Informasi',
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

  Widget _metaRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
        Icons.campaign_outlined,
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
