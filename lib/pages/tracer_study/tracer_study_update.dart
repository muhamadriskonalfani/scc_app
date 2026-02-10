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

  // Controllers
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
        errorMessage = e.toString();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// HEADER
      appBar: AppHeader(
        title: 'Update Tracer Study',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.tracerStudy),
      ),

      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _readonlyField('Nama Lengkap', '-'),
              _readonlyField('NIM', '-'),
              _readonlyField(
                'Fakultas',
                widget.tracerStudy.faculty?.name ?? '-',
              ),
              _readonlyField(
                'Program Studi',
                widget.tracerStudy.studyProgram?.name ?? '-',
              ),

              const Divider(height: 32),

              _input(
                label: 'Domicile',
                controller: domicileController,
                required: true,
              ),
              _input(
                label: 'WhatsApp',
                controller: whatsappController,
                required: true,
              ),
              _input(label: 'Tempat Kerja', controller: workplaceController),
              _input(
                label: 'Lama Kerja (bulan)',
                controller: durationController,
                type: TextInputType.number,
              ),

              _companyScale(),

              _input(label: 'Jabatan', controller: jobTitleController),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Perubahan'),
                ),
              ),

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

  Widget _readonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    bool required = false,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: required
            ? (v) => v == null || v.isEmpty ? '$label wajib diisi' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _companyScale() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: companyScale,
        decoration: InputDecoration(
          labelText: 'Skala Perusahaan',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
}
