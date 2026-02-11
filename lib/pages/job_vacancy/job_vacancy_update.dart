import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class JobVacancyUpdate extends StatefulWidget {
  final int jobVacancyId;

  const JobVacancyUpdate({super.key, required this.jobVacancyId});

  @override
  State<JobVacancyUpdate> createState() => _JobVacancyUpdateState();
}

class _JobVacancyUpdateState extends State<JobVacancyUpdate> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expiredAtController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadJobVacancy();
  }

  Future<void> _loadJobVacancy() async {
    // TODO:
    // final detail = await JobVacancyService(dio)
    //     .fetchJobVacancyDetail(widget.jobVacancyId);

    // Dummy sementara agar UI jalan
    setState(() {
      _titleController.text = 'Frontend Developer';
      _companyController.text = 'PT Teknologi Maju';
      _locationController.text = 'Jakarta';
      _descriptionController.text = 'Mengerjakan UI aplikasi';
      _expiredAtController.text = '2026-03-01';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // TODO:
      // await JobVacancyService(dio).updateJobVacancy(
      //   id: widget.jobVacancyId,
      //   title: _titleController.text,
      //   companyName: _companyController.text,
      //   location: _locationController.text,
      //   description: _descriptionController.text,
      //   expiredAt: _expiredAtController.text,
      // );

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ===== HEADER =====
      appBar: AppHeader(title: 'Update Info Lowongan Kerja', showBack: true),

      /// ===== CONTENT =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                label: 'Judul Lowongan',
                controller: _titleController,
              ),
              _buildInput(
                label: 'Nama Perusahaan',
                controller: _companyController,
              ),
              _buildInput(
                label: 'Lokasi Kerja',
                controller: _locationController,
              ),
              _buildTextarea(
                label: 'Deskripsi Pekerjaan',
                controller: _descriptionController,
              ),
              _buildDateInput(
                label: 'Tanggal Berakhir Lowongan',
                controller: _expiredAtController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Update & Ajukan Ulang',
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// ===== FOOTER =====
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xff444444)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextarea({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xff444444)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: 4,
            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xff444444)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: _inputDecoration(
              suffixIcon: Icons.calendar_today_outlined,
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );
              if (date != null) {
                controller.text = date.toIso8601String().split('T').first;
              }
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({IconData? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
    );
  }
}
