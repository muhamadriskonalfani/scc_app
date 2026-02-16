class ApiConfig {
  // =========================
  // BASE
  // =========================
  static const String baseUrl = 'http://192.168.1.7:8000/api';
  static const String mobile = '/mobile';

  // =========================
  // MOBILE AUTH
  // =========================
  static const String registerMeta = '$mobile/register-meta';
  static const String register = '$mobile/register';
  static const String login = '$mobile/login';
  static const String logout = '$mobile/logout';

  // =========================
  // MOBILE DASHBOARD
  // =========================
  static const String dashboard = '$mobile/dashboard';

  // =========================
  // MOBILE TRACER STUDY (ALUMNI)
  // =========================
  static const String tracerStudy = '$mobile/tracer-study';
  static const String tracerStudyStatus = '$mobile/tracer-study/status';

  // =========================
  // MOBILE PROFILE
  // =========================
  static const String profile = '$mobile/profile';

  // =========================
  // MOBILE CAMPUS DIRECTORY
  // =========================
  static const String directory = '$mobile/directory';
  static String directoryDetail(int id) => '$mobile/directory/$id';

  // =========================
  // MOBILE CAMPUS INFORMATION
  // =========================
  static const String campusInformation = '$mobile/information-campus';
  static String campusInformationDetail(int id) =>
      '$mobile/information-campus/$id';

  // =========================
  // MOBILE JOB VACANCY
  // =========================
  static const String jobVacancy = '$mobile/jobvacancy';
  static String jobVacancyDetail(int id) => '$mobile/jobvacancy/$id';
  static const String myJobVacancy = '$mobile/my-jobvacancy';

  // =========================
  // MOBILE APPRENTICESHIP
  // =========================
  static const String apprenticeship = '$mobile/apprenticeships';
  static String apprenticeshipDetail(int id) => '$mobile/apprenticeships/$id';
  static const String myApprenticeship = '$mobile/my-apprenticeships';
}
