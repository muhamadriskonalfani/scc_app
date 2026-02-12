import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../services/job_vacancy/job_vacancy_service.dart';
import '../../models/job_vacancy/job_vacancy_detail_model.dart';
import '../../config/dio_client.dart';

class JobVacancyUpdate extends StatefulWidget {
  final int jobVacancyId;

  const JobVacancyUpdate({super.key, required this.jobVacancyId});

  @override
  State<JobVacancyUpdate> createState() => _JobVacancyUpdateState();
}

class _JobVacancyUpdateState extends State<JobVacancyUpdate> {
  final _formKey = GlobalKey<FormState>();

  late final JobVacancyService _service;

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  // final salaryController = TextEditingController();
  final expiredAtController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _service = JobVacancyService(DioClient.instance);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await _service.getJobVacancyDetail(widget.jobVacancyId);

      if (!mounted) return;

      _fillForm(data);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal memuat data');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _fillForm(JobVacancyDetail data) {
    titleController.text = data.title;
    companyController.text = data.companyName;
    locationController.text = data.location;
    descriptionController.text = data.description;
    // salaryController.text = data.salary?.toString() ?? '';
    expiredAtController.text = data.expiredAt != null
        ? data.expiredAt!.toIso8601String().split('T').first
        : '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final message = await _service.updateJobVacancy(
        id: widget.jobVacancyId,
        data: {
          "title": titleController.text.trim(),
          "company_name": companyController.text.trim(),
          "location": locationController.text.trim(),
          "description": descriptionController.text.trim(),
          // "salary": salaryController.text.isEmpty
          //     ? null
          //     : int.tryParse(salaryController.text),
          "expired_at": expiredAtController.text.isEmpty
              ? null
              : expiredAtController.text,
        },
      );

      if (!mounted) return;

      _showSnackBar(message);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = expiredAtController.text.isNotEmpty
        ? DateTime.tryParse(expiredAtController.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      expiredAtController.text = picked.toIso8601String().split('T').first;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    // salaryController.dispose();
    expiredAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: const AppHeader(title: 'Update Lowongan Kerja', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      label: 'Judul Lowongan',
                      controller: titleController,
                    ),
                    _buildField(
                      label: 'Nama Perusahaan',
                      controller: companyController,
                    ),
                    _buildField(
                      label: 'Lokasi',
                      controller: locationController,
                    ),
                    _buildField(
                      label: 'Deskripsi Pekerjaan',
                      controller: descriptionController,
                      maxLines: 4,
                    ),
                    // _buildField(
                    //   label: 'Gaji',
                    //   controller: salaryController,
                    //   required: false,
                    // ),
                    _buildField(
                      label: 'Tanggal Berakhir',
                      controller: expiredAtController,
                      readOnly: true,
                      onTap: _selectDate,
                      required: false,
                    ),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            validator: required
                ? (value) => value == null || value.trim().isEmpty
                      ? 'Wajib diisi'
                      : null
                : null,
            keyboardType: label == 'Gaji'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Update & Ajukan Ulang',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
