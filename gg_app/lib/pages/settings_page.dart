import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // حالات السويتش (UI فقط حالياً)
  bool mfaEnabled = true;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool darkMode = false;
  String language = "English"; // English / Arabic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          // ===== Account =====
          const _SectionTitle("Account"),
          _Tile(
            icon: Icons.person_outline,
            title: "Profile",
            subtitle: "View your profile",
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),

          // ===== Security =====
          const _SectionTitle("Security"),
          SwitchListTile(
            secondary: const Icon(Icons.verified_user_outlined),
            title: const Text("MFA (Two-Factor Authentication)"),
            subtitle: const Text("Extra security for login (UI only)"),
            value: mfaEnabled,
            onChanged: (v) => setState(() => mfaEnabled = v),
          ),

          // ===== Notifications =====
          const _SectionTitle("Notifications"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text("Push notifications"),
            subtitle: const Text("Receive notifications on your device"),
            value: pushNotifications,
            onChanged: (v) => setState(() => pushNotifications = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text("Email notifications"),
            subtitle: const Text("Receive updates by email"),
            value: emailNotifications,
            onChanged: (v) => setState(() => emailNotifications = v),
          ),
          _Tile(
            icon: Icons.notifications_none_outlined,
            title: "Open Notifications",
            subtitle: "View all notifications",
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),

          // ===== Preferences =====
          const _SectionTitle("Preferences"),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark mode"),
            subtitle: const Text("UI only (no theme change yet)"),
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
          ),

          // Language switch (Dropdown)
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text("Language"),
            subtitle: Text(language),
            trailing: DropdownButton<String>(
              value: language,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Arabic", child: Text("Arabic")),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => language = v);
              },
            ),
          ),

          // ===== Actions =====
          const _SectionTitle("Actions"),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            subtitle: const Text("Return to Login screen"),
            onTap: () {
              // يرجع لصفحة login ويقفل كل الصفحات السابقة
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ===== ويدجت عنوان القسم =====
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}

// ===== Tile موحد عشان شكل الإعدادات يكون مرتب =====
class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
