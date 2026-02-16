import 'package:flutter/material.dart';
import '../models/tracer_study/tracer_study_model.dart';

// ====================
// SPLASH
// ====================
import '../pages/splash/splash_screen.dart';

// ====================
// AUTH
// ====================
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';

// ====================
// DASHBOARD
// ====================
import '../pages/dashboard/dashboard_index.dart';
import '../pages/dashboard/dashboard_career_info.dart';

// ====================
// PROFILE
// ====================
import '../pages/profile/profile_index.dart';
import '../pages/profile/profile_create.dart';
import '../pages/profile/profile_update.dart';
import '../pages/profile/profile_career_info.dart';
import '../pages/profile/profile_other_info.dart';

// ====================
// DIRECTORY
// ====================
import '../pages/directory/directory_index.dart';
import '../pages/directory/directory_detail.dart';

// ====================
// TRACER STUDY
// ====================
import '../pages/tracer_study/tracer_study_index.dart';
import '../pages/tracer_study/tracer_study_update.dart';

// ====================
// APPRENTICESHIP
// ====================
import '../pages/apprenticeship/apprenticeship_index.dart';
import '../pages/apprenticeship/apprenticeship_my.dart';
import '../pages/apprenticeship/apprenticeship_detail.dart';
import '../pages/apprenticeship/apprenticeship_create.dart';
import '../pages/apprenticeship/apprenticeship_update.dart';

// ====================
// JOB VACANCY
// ====================
import '../pages/job_vacancy/job_vacancy_index.dart';
import '../pages/job_vacancy/job_vacancy_my.dart';
import '../pages/job_vacancy/job_vacancy_detail.dart';
import '../pages/job_vacancy/job_vacancy_create.dart';
import '../pages/job_vacancy/job_vacancy_update.dart';

// ====================
// CAMPUS
// ====================
import '../pages/campus/campus_index.dart';
import '../pages/campus/campus_detail.dart';

// ====================
// HELP CENTER
// ====================
import '../pages/help_center/help_center_page.dart';

class AppRoutes {
  // ========= SPLASH =========
  static const splash = '/';

  // ========= AUTH =========
  static const login = '/login';
  static const register = '/register';

  // ========= DASHBOARD =========
  static const dashboard = '/dashboard';
  static const dashboardCareerInfo = '/dashboard/career-info';

  // ========= PROFILE =========
  static const profile = '/profile';
  static const profileCreate = '/profile/create';
  static const profileUpdate = '/profile/update';
  static const profileCareerInfo = '/profile/career-info';
  static const profileOtherInfo = '/profile/other-info';

  // ========= DIRECTORY =========
  static const directory = '/directory';
  static const directoryDetail = '/directory/detail';

  // ========= TRACER STUDY =========
  static const tracerStudy = '/tracer-study';
  static const tracerStudyUpdate = '/tracer-study/update';

  // ========= APPRENTICESHIP =========
  static const apprenticeship = '/apprenticeship';
  static const apprenticeshipMy = '/apprenticeship/my';
  static const apprenticeshipDetail = '/apprenticeship/detail';
  static const apprenticeshipCreate = '/apprenticeship/create';
  static const apprenticeshipUpdate = '/apprenticeship/update';

  // ========= JOB VACANCY =========
  static const jobVacancy = '/job-vacancy';
  static const jobVacancyMy = '/job-vacancy/my';
  static const jobVacancyDetail = '/job-vacancy/detail';
  static const jobVacancyCreate = '/job-vacancy/create';
  static const jobVacancyUpdate = '/job-vacancy/update';

  // ========= CAMPUS =========
  static const campus = '/campus';
  static const campusDetail = '/campus/detail';

  // ========= HELP CENTER =========
  static const helpCenter = '/help-center';

  // ========= ROUTES MAP =========
  static final Map<String, WidgetBuilder> routes = {
    // Splash
    splash: (_) => const SplashScreen(),

    // Auth
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),

    // Dashboard
    dashboard: (_) => const DashboardIndex(),
    dashboardCareerInfo: (_) => const DashboardCareerInfo(),

    // Profile
    profile: (_) => const ProfileIndex(),
    profileCreate: (_) => const ProfileCreateIndex(),
    profileUpdate: (_) => const ProfileUpdateIndex(),
    profileCareerInfo: (_) => const ProfileCareerInfo(),
    profileOtherInfo: (_) => const ProfileOtherInfo(),

    // Directory
    directory: (_) => const DirectoryIndex(),
    directoryDetail: (_) => const DirectoryDetail(),

    // Tracer Study
    tracerStudy: (_) => const TracerStudyIndex(),
    tracerStudyUpdate: (context) {
      final tracerStudy =
          ModalRoute.of(context)!.settings.arguments as TracerStudyModel;

      return TracerStudyUpdate(tracerStudy: tracerStudy);
    },

    // Apprenticeship
    apprenticeship: (_) => const ApprenticeshipIndex(),
    apprenticeshipMy: (_) => const ApprenticeshipMy(),
    apprenticeshipDetail: (context) {
      final int id = ModalRoute.of(context)!.settings.arguments as int;
      return ApprenticeshipDetailPage(apprenticeshipId: id);
    },
    apprenticeshipCreate: (_) => const ApprenticeshipCreate(),
    apprenticeshipUpdate: (context) {
      final int id = ModalRoute.of(context)!.settings.arguments as int;
      return ApprenticeshipUpdate(apprenticeshipId: id);
    },

    // Job Vacancy
    jobVacancy: (_) => const JobVacancyIndex(),
    jobVacancyMy: (_) => const JobVacancyMy(),
    jobVacancyDetail: (context) {
      final int id = ModalRoute.of(context)!.settings.arguments as int;
      return JobVacancyDetailPage(jobVacancyId: id);
    },
    jobVacancyCreate: (_) => const JobVacancyCreate(),
    jobVacancyUpdate: (context) {
      final int id = ModalRoute.of(context)!.settings.arguments as int;
      return JobVacancyUpdate(jobVacancyId: id);
    },

    // Campus
    campus: (_) => const CampusIndex(),
    campusDetail: (_) => const CampusDetail(),

    // Help Center
    helpCenter: (_) => const HelpCenterPage(),
  };
}
