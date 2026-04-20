import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool mfaEnabled = true;
  bool pushNotifications = true;

  final String accountType = "User";

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF244379);
    const Color pageBg = Color(0xFFF3F5F7);
    const Color textGrey = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 210,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(42),
                      bottomRight: Radius.circular(42),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF86B2ED),
                        Color(0xFFA9D2EA),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(color: pageBg),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.profile,
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    children: [
                      _section("Account"),
                      _card(
                        child: _tile(
                          icon: Icons.badge_outlined,
                          title: "Account Type",
                          subtitle: accountType,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _section("Security"),
                      _card(
                        child: SwitchListTile(
                          secondary: const Icon(
                            Icons.verified_user_outlined,
                            color: darkBlue,
                          ),
                          title: const Text(
                            "MFA (Two-Factor Authentication)",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: darkBlue,
                            ),
                          ),
                          subtitle: Text(
                            mfaEnabled
                                ? "Authentication required"
                                : "Login without authentication",
                            style: const TextStyle(color: textGrey),
                          ),
                          value: mfaEnabled,
                          onChanged: (v) {
                            setState(() => mfaEnabled = v);
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      _section("Notifications"),
                      _card(
                        child: SwitchListTile(
                          secondary: const Icon(
                            Icons.notifications_outlined,
                            color: darkBlue,
                          ),
                          title: const Text(
                            "Push notifications",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: darkBlue,
                            ),
                          ),
                          subtitle: Text(
                            pushNotifications
                                ? "Notifications ON"
                                : "Notifications OFF",
                            style: const TextStyle(color: textGrey),
                          ),
                          value: pushNotifications,
                          onChanged: (v) {
                            setState(() => pushNotifications = v);
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      _section("Actions"),
                      _card(
                        child: Column(
                          children: [
                            _tile(
                              icon: Icons.delete_outline,
                              title: "Delete Account",
                              subtitle: "Permanently remove your account",
                              color: Colors.red,
                              onTap: () => _showDeleteAccountDialog(context),
                            ),
                            const Divider(),
                            _tile(
                              icon: Icons.logout,
                              title: "Logout",
                              subtitle: "Return to Login",
                              color: Colors.red,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x149AA6B2),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = const Color(0xFF244379),
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF6B7280)),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
