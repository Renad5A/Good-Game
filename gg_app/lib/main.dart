import 'package:flutter/material.dart';

// routes
import 'core/app_routes.dart';

// pages
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/otp_page.dart';
import 'pages/home_page.dart';
import 'pages/groups_page.dart';
import 'pages/group_details_page.dart';
import 'pages/search_page.dart';
import 'pages/add_activity_page.dart';
import 'pages/profile_page.dart';
import 'pages/notifications_page.dart';
import 'pages/chat_page.dart';
import 'pages/settings_page.dart';
import 'pages/skill_level_page.dart';

void main() {
  runApp(const GGApp());
}

class GGApp extends StatelessWidget {
  const GGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GG App',

      // أول صفحة تفتح
      initialRoute: AppRoutes.login,

      // ربط كل الصفحات
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
        AppRoutes.otp: (context) => const OtpPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.groups: (context) => const GroupsPage(),
        AppRoutes.groupDetails: (context) {
          final group =
              ModalRoute.of(context)!.settings.arguments as Group;
          return GroupDetailsPage(group: group);
        },
        AppRoutes.search: (context) => const SearchPage(),
        AppRoutes.addActivity: (context) => const AddActivityPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.notifications: (context) => const NotificationsPage(),
        AppRoutes.chat: (context) => const ChatPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.skillLevel: (context) => const SkillLevelPage(),
      },
    );
  }
}
