import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class JobVacancyCreate extends StatefulWidget {
  const JobVacancyCreate({super.key});

  @override
  State<JobVacancyCreate> createState() => _JobVacancyCreateState();
}

class _JobVacancyCreateState extends State<JobVacancyCreate> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      // ================= HEADER =================
      appBar: AppHeader(title: 'Tambah Info Lowongan Kerja', showBack: true),

      // ================= CONTENT =================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInput(
                  label: 'Judul Lowongan',
                  controller: titleController,
                  hint: 'Contoh: Backend Developer Laravel',
                ),
                _buildInput(
                  label: 'Nama Perusahaan',
                  controller: companyController,
                  hint: 'PT Teknologi Nusantara',
                ),
                _buildInput(
                  label: 'Lokasi',
                  controller: locationController,
                  hint: 'Jakarta / Remote',
                ),
                _buildTextarea(
                  label: 'Deskripsi Pekerjaan',
                  controller: descriptionController,
                  hint:
                      'Jelaskan kualifikasi, tanggung jawab, dan benefit pekerjaan',
                ),
                _buildDateInput(
                  label: 'Tanggal Berakhir (Opsional)',
                  controller: expiredAtController,
                ),
                const SizedBox(height: 24),

                // ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563eb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Simpan Lowongan Pekerjaan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ================= FOOTER =================
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
    );
  }

  // ================= HANDLER =================
  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form valid, siap kirim ke API')),
      );
    }
  }

  // ================= WIDGETS =================
  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) =>
              v == null || v.isEmpty ? 'Field ini wajib diisi' : null,
          decoration: _inputDecoration(hint),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildTextarea({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 4,
          validator: (v) =>
              v == null || v.isEmpty ? 'Field ini wajib diisi' : null,
          decoration: _inputDecoration(hint),
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
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: _inputDecoration('Pilih tanggal'),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
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

  // ================= STYLE =================
  TextStyle get _labelStyle => const TextStyle(
    fontSize: 14,
    color: Color(0xff444444),
    fontWeight: FontWeight.w500,
  );

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14),
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
