import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/dio_client.dart';
import '../../models/apprenticeship/apprenticeship_model.dart';
import '../../models/apprenticeship/apprenticeship_response_model.dart';
import '../../services/apprenticeship/apprenticeship_service.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_bar.dart';

class ApprenticeshipMy extends StatefulWidget {
  const ApprenticeshipMy({super.key});

  @override
  State<ApprenticeshipMy> createState() => _ApprenticeshipMyState();
}

class _ApprenticeshipMyState extends State<ApprenticeshipMy> {
  final ApprenticeshipService _service = ApprenticeshipService(
    DioClient.instance,
  );

  final List<ApprenticeshipModel> _items = [];

  bool _isLoading = true;
  bool _isLoadMore = false;
  String? _error;

  int _currentPage = 1;
  int _lastPage = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchData({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _items.clear();
      }

      setState(() {
        if (!refresh) _isLoading = true;
        _error = null;
      });

      final ApprenticeshipResponse response = await _service
          .getMyApprenticeships(page: _currentPage);

      setState(() {
        _items.addAll(response.data);
        _lastPage = response.meta.lastPage;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadMore &&
        _currentPage < _lastPage) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadMore = true);
    _currentPage++;
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppHeader(
        title: 'Magang Saya',
        showBack: true,
        actionIcon: Icons.add_outlined,
        onBack: () => Navigator.pop(context),
        onActionPressed: () {
          Navigator.pushNamed(context, AppRoutes.apprenticeshipCreate);
        },
      ),
      bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'Anda belum memiliki data magang.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchData(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _items.length + (_isLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final item = _items[index];
          return _buildCard(item);
        },
      ),
    );
  }

  Widget _buildCard(ApprenticeshipModel item) {
    final formattedDate = DateFormat('dd MMM yyyy').format(item.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.image != null
                ? Image.network(
                    '${DioClient.instance.options.baseUrl.replaceAll('/api', '')}/storage/${item.image}',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          const SizedBox(width: 14),

          /// BODY
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.companyName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff6b7280),
                  ),
                ),
                const SizedBox(height: 8),
                _metaRow(Icons.location_on_outlined, item.location),
                _metaRow(Icons.access_time_outlined, 'Dibuat $formattedDate'),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 6),

                /// FOOTER ACTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusBadge(status: item.status),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.apprenticeshipDetail,
                              arguments: {'id': item.id},
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.apprenticeshipUpdate,
                              arguments: {'id': item.id},
                            );
                            if (result == true) {
                              _fetchData(refresh: true);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xff9ca3af)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xff6b7280)),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 72,
      height: 72,
      color: const Color(0xffe5e7eb),
      child: const Icon(Icons.work_outline, color: Color(0xff9ca3af)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get color {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
