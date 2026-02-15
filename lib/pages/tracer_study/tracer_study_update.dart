import 'package:flutter/material.dart';
import '../../models/tracer_study/tracer_study_model.dart';
import '../../services/tracer_study/tracer_study_service.dart';
import '../../config/dio_client.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_dropdown.dart';
import '../../widgets/app_button.dart';

class TracerStudyUpdate extends StatefulWidget {
  final TracerStudyModel tracerStudy;

  const TracerStudyUpdate({super.key, required this.tracerStudy});

  @override
  State<TracerStudyUpdate> createState() => _TracerStudyUpdateState();
}

class _TracerStudyUpdateState extends State<TracerStudyUpdate> {
  final _formKey = GlobalKey<FormState>();
  late final TracerStudyService _service;

  bool isLoading = false;
  String? errorMessage;

  String? employmentStatus;
  String? companyScale;
  String? jobCategory;
  String? employmentType;
  String? employmentSector;
  String? monthlyIncomeRange;
  String? jobStudyRelevanceLevel;

  late TextEditingController workplaceController;
  late TextEditingController jobTitleController;
  late TextEditingController suggestionController;

  @override
  void initState() {
    super.initState();
    _service = TracerStudyService(DioClient.instance);

    employmentStatus = widget.tracerStudy.employmentStatus;
    companyScale = widget.tracerStudy.companyScale;
    jobCategory = widget.tracerStudy.jobCategory;
    employmentType = widget.tracerStudy.employmentType;
    employmentSector = widget.tracerStudy.employmentSector;
    monthlyIncomeRange = widget.tracerStudy.monthlyIncomeRange;
    jobStudyRelevanceLevel = widget.tracerStudy.jobStudyRelevanceLevel;

    workplaceController = TextEditingController(
      text: widget.tracerStudy.currentWorkplace,
    );
    jobTitleController = TextEditingController(
      text: widget.tracerStudy.jobTitle,
    );
    suggestionController = TextEditingController(
      text: widget.tracerStudy.suggestionForUniversity,
    );
  }

  @override
  void dispose() {
    workplaceController.dispose();
    jobTitleController.dispose();
    suggestionController.dispose();
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
        employmentStatus: employmentStatus,
        currentWorkplace: workplaceController.text.isEmpty
            ? null
            : workplaceController.text,
        companyScale: companyScale,
        jobTitle: jobTitleController.text.isEmpty
            ? null
            : jobTitleController.text,
        jobCategory: jobCategory,
        employmentType: employmentType,
        employmentSector: employmentSector,
        monthlyIncomeRange: monthlyIncomeRange,
        jobStudyRelevanceLevel: jobStudyRelevanceLevel,
        suggestionForUniversity: suggestionController.text.isEmpty
            ? null
            : suggestionController.text,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool get isWorking => employmentStatus == 'bekerja';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: const AppHeader(title: 'Perbarui Tracer Study'),
      bottomNavigationBar: const AppBottomBar(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===============================
              /// SECTION 1 – DATA AKADEMIK
              /// ===============================
              _buildSectionCard(
                title: 'Informasi Akademik',
                child: Column(
                  children: [
                    _readonlyItem('Nama', widget.tracerStudy.name),
                    _readonlyItem('NIM', widget.tracerStudy.nim),
                    _readonlyItem('Fakultas', widget.tracerStudy.faculty),
                    _readonlyItem(
                      'Program Studi',
                      widget.tracerStudy.studyProgram,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===============================
              /// SECTION 2 – INFORMASI KARIR
              /// ===============================
              _buildSectionCard(
                title: 'Informasi Karir',
                child: Column(
                  children: [
                    AppDropdown<String>(
                      label: 'Status Pekerjaan',
                      value: employmentStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'bekerja',
                          child: Text('Bekerja'),
                        ),
                        DropdownMenuItem(
                          value: 'wirausaha',
                          child: Text('Wirausaha'),
                        ),
                        DropdownMenuItem(
                          value: 'lanjut studi',
                          child: Text('Lanjut Studi'),
                        ),
                        DropdownMenuItem(
                          value: 'belum bekerja',
                          child: Text('Belum Bekerja'),
                        ),
                      ],
                      onChanged: (v) => setState(() => employmentStatus = v),
                    ),
                    const SizedBox(height: 16),

                    if (isWorking) ...[
                      AppInput(
                        label: 'Tempat Bekerja',
                        hint: 'Masukkan nama perusahaan',
                        controller: workplaceController,
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'Jabatan',
                        hint: 'Masukkan jabatan',
                        controller: jobTitleController,
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Skala Perusahaan',
                        value: companyScale,
                        items: const [
                          DropdownMenuItem(
                            value: 'local',
                            child: Text('Lokal'),
                          ),
                          DropdownMenuItem(
                            value: 'national',
                            child: Text('Nasional'),
                          ),
                          DropdownMenuItem(
                            value: 'international',
                            child: Text('Internasional'),
                          ),
                        ],
                        onChanged: (v) => setState(() => companyScale = v),
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Kategori Pekerjaan',
                        value: jobCategory,
                        items: const [
                          DropdownMenuItem(
                            value: 'formal',
                            child: Text('Formal'),
                          ),
                          DropdownMenuItem(
                            value: 'informal',
                            child: Text('Informal'),
                          ),
                          DropdownMenuItem(
                            value: 'wirausaha',
                            child: Text('Wirausaha'),
                          ),
                          DropdownMenuItem(
                            value: 'freelance',
                            child: Text('Freelance'),
                          ),
                        ],
                        onChanged: (v) => setState(() => jobCategory = v),
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Jenis Pekerjaan',
                        value: employmentType,
                        items: const [
                          DropdownMenuItem(
                            value: 'full-time',
                            child: Text('Full Time'),
                          ),
                          DropdownMenuItem(
                            value: 'part-time',
                            child: Text('Part Time'),
                          ),
                          DropdownMenuItem(
                            value: 'kontrak',
                            child: Text('Kontrak'),
                          ),
                          DropdownMenuItem(
                            value: 'magang',
                            child: Text('Magang'),
                          ),
                        ],
                        onChanged: (v) => setState(() => employmentType = v),
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Sektor Pekerjaan',
                        value: employmentSector,
                        items: const [
                          DropdownMenuItem(
                            value: 'pendidikan',
                            child: Text('Pendidikan'),
                          ),
                          DropdownMenuItem(value: 'IT', child: Text('IT')),
                          DropdownMenuItem(
                            value: 'keuangan',
                            child: Text('Keuangan'),
                          ),
                          DropdownMenuItem(
                            value: 'manufaktur',
                            child: Text('Manufaktur'),
                          ),
                          DropdownMenuItem(
                            value: 'lainnya',
                            child: Text('Lainnya'),
                          ),
                        ],
                        onChanged: (v) => setState(() => employmentSector = v),
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Rentang Gaji',
                        value: monthlyIncomeRange,
                        items: const [
                          DropdownMenuItem(
                            value: '<5jt',
                            child: Text('< 5 Juta'),
                          ),
                          DropdownMenuItem(
                            value: '5-10jt',
                            child: Text('5 - 10 Juta'),
                          ),
                          DropdownMenuItem(
                            value: '>10jt',
                            child: Text('> 10 Juta'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => monthlyIncomeRange = v),
                      ),
                      const SizedBox(height: 16),

                      AppDropdown<String>(
                        label: 'Relevansi Studi',
                        value: jobStudyRelevanceLevel,
                        items: const [
                          DropdownMenuItem(
                            value: 'sangat sesuai',
                            child: Text('Sangat Sesuai'),
                          ),
                          DropdownMenuItem(
                            value: 'sesuai',
                            child: Text('Sesuai'),
                          ),
                          DropdownMenuItem(
                            value: 'kurang',
                            child: Text('Kurang Sesuai'),
                          ),
                          DropdownMenuItem(
                            value: 'tidak sesuai',
                            child: Text('Tidak Sesuai'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => jobStudyRelevanceLevel = v),
                      ),
                      const SizedBox(height: 16),
                    ],

                    AppInput(
                      label: 'Saran Untuk Kampus',
                      hint: 'Tulis saran untuk pengembangan kampus',
                      controller: suggestionController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTON
              AppButton(
                label: 'Simpan Perubahan',
                icon: Icons.save_outlined,
                isLoading: isLoading,
                onPressed: submit,
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 14),
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

  /// ===============================
  /// COMPONENTS
  /// ===============================

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 16),
          child,
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
}
