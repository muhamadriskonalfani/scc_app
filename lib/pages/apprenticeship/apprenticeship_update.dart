import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class ApprenticeshipUpdate extends StatefulWidget {
  final int apprenticeshipId;

  const ApprenticeshipUpdate({super.key, required this.apprenticeshipId});

  @override
  State<ApprenticeshipUpdate> createState() => _ApprenticeshipUpdateState();
}

class _ApprenticeshipUpdateState extends State<ApprenticeshipUpdate> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController expiredAtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // TODO:
    // Panggil API detail magang berdasarkan widget.apprenticeshipId
    // lalu isi controller (mirip old() di Laravel)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Update Info Magang', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(label: 'Judul Magang', controller: titleController),
              _buildInput(
                label: 'Nama Perusahaan',
                controller: companyController,
              ),
              _buildInput(label: 'Lokasi', controller: locationController),
              _buildTextarea(
                label: 'Deskripsi Magang',
                controller: descriptionController,
              ),
              _buildInput(
                label: 'Tanggal Berakhir',
                controller: expiredAtController,
                hint: 'YYYY-MM-DD',
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update & Ajukan Ulang',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            validator: (value) {
              if (!readOnly && (value == null || value.isEmpty)) {
                return 'Wajib diisi';
              }
              return null;
            },
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      expiredAtController.text = picked.toIso8601String().split('T').first;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO:
    // Panggil ApprenticeshipService.update(
    //   id: widget.apprenticeshipId,
    //   data: ...
    // )

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Update berhasil')));
  }
}
