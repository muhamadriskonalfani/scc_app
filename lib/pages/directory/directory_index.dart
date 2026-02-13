import 'package:flutter/material.dart';

import '../../config/dio_client.dart';
import '../../services/directory/directory_service.dart';
import '../../services/meta/meta_service.dart';

import '../../models/directory/directory_user_model.dart';
import '../../models/directory/directory_meta_model.dart';
import '../../models/meta/faculty_model.dart';
import '../../models/meta/study_program_model.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../routes/app_routes.dart';
import '../../config/api_config.dart';

class DirectoryIndex extends StatefulWidget {
  const DirectoryIndex({super.key});

  @override
  State<DirectoryIndex> createState() => _DirectoryIndexState();
}

class _DirectoryIndexState extends State<DirectoryIndex> {
  late DirectoryService _directoryService;
  late MetaService _metaService;

  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isLoadMore = false;

  List<DirectoryUserModel> _users = [];
  DirectoryMetaModel? _meta;

  List<FacultyModel> _faculties = [];
  List<StudyProgramModel> _studyPrograms = [];

  String? _type;
  int? _selectedFacultyId;
  int? _selectedStudyProgramId;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _directoryService = DirectoryService(DioClient.instance);
    _metaService = MetaService(DioClient.instance);
    _initPage();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _initPage() async {
    await _loadMeta();
    await _fetchDirectory(refresh: true);
  }

  Future<void> _loadMeta() async {
    try {
      final meta = await _metaService.getRegisterMeta();
      setState(() {
        _faculties = meta.faculties;
        _studyPrograms = meta.studyPrograms;
      });
    } catch (_) {}
  }

  Future<void> _fetchDirectory({bool refresh = false}) async {
    if (refresh) {
      _meta = null;
      _users.clear();
    }

    setState(() => _isLoading = _users.isEmpty);

    try {
      final result = await _directoryService.getDirectory(
        type: _type,
        facultyId: _selectedFacultyId,
        studyProgramId: _selectedStudyProgramId,
        entryYear: _selectedYear,
        page: refresh ? 1 : (_meta?.currentPage ?? 0) + 1,
      );

      setState(() {
        if (refresh) {
          _users = result.users;
        } else {
          _users.addAll(result.users);
        }
        _meta = result.meta;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_meta == null) return;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadMore &&
        _meta!.currentPage < _meta!.lastPage) {
      _isLoadMore = true;
      _fetchDirectory();
    }
  }

  List<StudyProgramModel> get _filteredStudyPrograms {
    if (_selectedFacultyId == null) return _studyPrograms;
    return _studyPrograms
        .where((p) => p.facultyId == _selectedFacultyId)
        .toList();
  }

  String _statusLabel(String status) =>
      status == 'student' ? 'Mahasiswa' : 'Alumni';

  Color _statusColor(String status) =>
      status == 'student' ? Colors.blue : Colors.green;

  Widget _buildAvatar(DirectoryUserModel user) {
    if (user.photo != null && user.photo!.isNotEmpty) {
      final imageUrl =
          '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/${user.photo}';

      return CircleAvatar(radius: 26, backgroundImage: NetworkImage(imageUrl));
    }

    return CircleAvatar(
      radius: 26,
      backgroundImage: AssetImage(
        user.gender == 'female'
            ? 'assets/images/profile_female.png'
            : 'assets/images/profile_male.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppHeader(
        title: 'Direktori Kampus',
        onBack: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
      ),
      body: Column(
        children: [
          _buildTopFilterButton(),
          Expanded(child: _buildList()),
        ],
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 3),
    );
  }

  Widget _buildTopFilterButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.filter_list),
          label: const Text(
            "Filter Direktori",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          onPressed: _showFilterSheet,
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter Direktori",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDropdownType(),
                const SizedBox(height: 16),
                _buildDropdownFaculty(),
                const SizedBox(height: 16),
                _buildDropdownStudyProgram(),
                const SizedBox(height: 16),
                _buildDropdownYear(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _fetchDirectory(refresh: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text("Terapkan Filter"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<String>(
      initialValue: _type,
      decoration: _inputDecoration("Tipe"),
      items: const [
        DropdownMenuItem(value: 'student', child: Text('Mahasiswa')),
        DropdownMenuItem(value: 'alumni', child: Text('Alumni')),
      ],
      onChanged: (val) => setState(() => _type = val),
    );
  }

  Widget _buildDropdownFaculty() {
    return DropdownButtonFormField<int>(
      initialValue: _selectedFacultyId,
      decoration: _inputDecoration("Fakultas"),
      items: _faculties
          .map((f) => DropdownMenuItem(value: f.id, child: Text(f.name)))
          .toList(),
      onChanged: (val) {
        setState(() {
          _selectedFacultyId = val;
          _selectedStudyProgramId = null;
        });
      },
    );
  }

  Widget _buildDropdownStudyProgram() {
    return DropdownButtonFormField<int>(
      initialValue: _selectedStudyProgramId,
      decoration: _inputDecoration("Program Studi"),
      items: _filteredStudyPrograms
          .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
          .toList(),
      onChanged: (val) => setState(() => _selectedStudyProgramId = val),
    );
  }

  Widget _buildDropdownYear() {
    return DropdownButtonFormField<int>(
      initialValue: _selectedYear,
      decoration: _inputDecoration("Angkatan"),
      items: List.generate(10, (index) {
        final year = DateTime.now().year - index;
        return DropdownMenuItem(value: year, child: Text(year.toString()));
      }),
      onChanged: (val) => setState(() => _selectedYear = val),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    return RefreshIndicator(
      onRefresh: () => _fetchDirectory(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: _users.length + 1,
        itemBuilder: (context, index) {
          if (index == _users.length) {
            return _isLoadMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          }

          final user = _users[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.directoryDetail,
                arguments: user.id,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildAvatar(user),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.studyProgram ?? '-'} · ${user.entryYear ?? '-'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _statusLabel(user.status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(user.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
