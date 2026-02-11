import 'package:flutter/material.dart';
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
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _service.getInformationDetail(id);

      setState(() {
        _data = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildImageHeader() {
    if (_data!.image != null && _data!.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          _data!.image!,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.campaign_outlined,
          size: 60,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_data == null) {
      return const Center(
        child: Text(
          'Informasi tidak ditemukan',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          _buildImageHeader(),

          const SizedBox(height: 20),

          /// TITLE CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _data!.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _data!.createdAt,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// DESCRIPTION CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _data!.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      /// HEADER
      appBar: const AppHeader(title: 'Detail Informasi'),

      body: _buildContent(),

      /// BOTTOM BAR
      bottomNavigationBar: const AppBottomBar(currentIndex: 3),
    );
  }
}
