import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class ApprenticeshipCreate extends StatefulWidget {
  const ApprenticeshipCreate({super.key});

  @override
  State<ApprenticeshipCreate> createState() => _ApprenticeshipCreateState();
}

class _ApprenticeshipCreateState extends State<ApprenticeshipCreate> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController expiredAtController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    expiredAtController.dispose();
    super.dispose();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      // NANTI:
      // ApprenticeshipService.store(...)
      debugPrint('Submit form magang');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Tambah Info Magang', showBack: true),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                label: 'Judul Magang',
                controller: titleController,
                required: true,
              ),
              _buildInput(
                label: 'Nama Perusahaan',
                controller: companyController,
                required: true,
              ),
              _buildInput(
                label: 'Lokasi',
                controller: locationController,
                required: true,
              ),
              _buildTextarea(
                label: 'Deskripsi Magang',
                controller: descriptionController,
                required: true,
              ),
              _buildDateInput(
                label: 'Tanggal Berakhir (Opsional)',
                controller: expiredAtController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan Informasi Magang',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
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
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: required
              ? (value) => value == null || value.isEmpty ? 'Wajib diisi' : null
              : null,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildTextarea({
    required String label,
    required TextEditingController controller,
    bool required = false,
  }) {
    return Column(
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
          validator: required
              ? (value) => value == null || value.isEmpty ? 'Wajib diisi' : null
              : null,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDateInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            );
            if (date != null) {
              controller.text =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }
          },
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  InputDecoration _inputDecoration({IconData? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
    );
  }
}
