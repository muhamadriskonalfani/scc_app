import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../services/campus/campus_information_service.dart';
import '../../models/campus/campus_information_detail_model.dart';
import '../../config/api_config.dart';
import '../../routes/app_routes.dart';

class CampusDetail extends StatefulWidget {
  const CampusDetail({super.key});

  @override
  State<CampusDetail> createState() => _CampusDetailState();
}

class _CampusDetailState extends State<CampusDetail> {
  late CampusInformationService _service;

  bool _loading = true;
  CampusInformationDetailModel? _data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int id = ModalRoute.of(context)!.settings.arguments as int;

    _service = CampusInformationService(
      Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)),
    );

    _fetchDetail(id);
  }

  Future<void> _fetchDetail(int id) async {
    try {
      final result = await _service.getInformationDetail(id);
      setState(() {
        _data = result;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      /// HEADER
      appBar: AppHeader(
        title: 'Info Kampus',
        onBack: () => Navigator.pushReplacementNamed(context, AppRoutes.campus),
      ),

      body: Column(
        children: [
          /// CONTENT
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _data == null
                ? const Center(
                    child: Text(
                      'Informasi tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child:
                              _data!.image != null && _data!.image!.isNotEmpty
                              ? Image.network(
                                  _data!.image!,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/logo.png',
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        const SizedBox(height: 16),

                        /// INFO UTAMA
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFF97316), // fresh-orange
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Dipublikasikan ${_data!.createdAt}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// DESKRIPSI
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Deskripsi Informasi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _data!.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.7,
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),

      /// FOOTER
      bottomNavigationBar: const AppBottomBar(currentIndex: 3),
    );
  }
}
