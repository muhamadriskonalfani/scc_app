import 'package:flutter/material.dart';
import '../../models/tracer_study/tracer_study_model.dart';
import '../../services/tracer_study/tracer_study_service.dart';
import '../../config/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class TracerStudyUpdate extends StatefulWidget {
  final TracerStudyModel tracerStudy;

  const TracerStudyUpdate({super.key, required this.tracerStudy});

  @override
  State<TracerStudyUpdate> createState() => _TracerStudyUpdateState();
}

class _TracerStudyUpdateState extends State<TracerStudyUpdate> {
  final _formKey = GlobalKey<FormState>();
  late final TracerStudyService _service;

  late TextEditingController domicileController;
  late TextEditingController whatsappController;
  late TextEditingController workplaceController;
  late TextEditingController durationController;
  late TextEditingController jobTitleController;

  String? companyScale;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _service = TracerStudyService(DioClient.instance);

    domicileController = TextEditingController(
      text: widget.tracerStudy.domicile,
    );
    whatsappController = TextEditingController(
      text: widget.tracerStudy.whatsappNumber,
    );
    workplaceController = TextEditingController(
      text: widget.tracerStudy.currentWorkplace,
    );
    durationController = TextEditingController(
      text: widget.tracerStudy.currentJobDurationMonths?.toString(),
    );
    jobTitleController = TextEditingController(
      text: widget.tracerStudy.jobTitle,
    );

    companyScale = widget.tracerStudy.companyScale;
  }

  @override
  void dispose() {
    domicileController.dispose();
    whatsappController.dispose();
    workplaceController.dispose();
    durationController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _service.updateTracerStudy(
        domicile: domicileController.text,
        whatsappNumber: whatsappController.text,
        currentWorkplace: workplaceController.text.isEmpty
            ? null
            : workplaceController.text,
        currentJobDurationMonths: durationController.text.isEmpty
            ? null
            : int.parse(durationController.text),
        companyScale: companyScale,
        jobTitle: jobTitleController.text.isEmpty
            ? null
            : jobTitleController.text,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: const AppHeader(title: 'Perbarui Tracer Study'),
      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Informasi Akademik'),
              const SizedBox(height: 12),
              _readonlyCard(),

              const SizedBox(height: 24),

              _sectionTitle('Informasi Karir'),
              const SizedBox(height: 12),

              _inputField(
                label: 'Domisili',
                controller: domicileController,
                required: true,
              ),
              _inputField(
                label: 'Nomor WhatsApp',
                controller: whatsappController,
                required: true,
                keyboardType: TextInputType.phone,
              ),
              _inputField(
                label: 'Tempat Bekerja',
                controller: workplaceController,
              ),
              _inputField(
                label: 'Lama Kerja (bulan)',
                controller: durationController,
                keyboardType: TextInputType.number,
              ),
              _companyScaleDropdown(),
              _inputField(label: 'Jabatan', controller: jobTitleController),

              const SizedBox(height: 24),

              _gradientButton(),

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xff111827),
      ),
    );
  }

  Widget _readonlyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _readonlyItem('Fakultas', widget.tracerStudy.faculty?.name),
          _readonlyItem('Program Studi', widget.tracerStudy.studyProgram?.name),
        ],
      ),
    );
  }

  Widget _readonlyItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xff6b7280)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: required
            ? (v) => v == null || v.isEmpty ? '$label wajib diisi' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _companyScaleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: companyScale,
        decoration: InputDecoration(
          labelText: 'Skala Perusahaan',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: const [
          DropdownMenuItem(value: 'local', child: Text('Lokal')),
          DropdownMenuItem(value: 'national', child: Text('Nasional')),
          DropdownMenuItem(
            value: 'international',
            child: Text('Internasional'),
          ),
        ],
        onChanged: (value) {
          setState(() => companyScale = value);
        },
      ),
    );
  }

  Widget _gradientButton() {
    return GestureDetector(
      onTap: isLoading ? null : submit,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2563EB), // biru utama
              Color(0xFF3B82F6), // biru lebih terang (soft)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
