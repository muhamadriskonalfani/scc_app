import '../config/api_config.dart';
import '../models/dashboard_response_model.dart';
import '../config/dio_client.dart';

class DashboardService {
  Future<DashboardResponse> fetchDashboard() async {
    final response = await DioClient.instance.get(ApiConfig.dashboard);
    return DashboardResponse.fromJson(response.data);
  }
}
