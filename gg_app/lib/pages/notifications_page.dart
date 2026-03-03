import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  int _navIndex = 0;

  // بيانات تجريبية مثل الصورة
  final List<_Notif> items = [
    _Notif("New Member Joined",
        'Faisal joined your "Evening Running" group',
        "Feb 17, 10:30 AM", false, Icons.group, Color(0xFFDFF7EE), Color(0xFF10B981)),

    _Notif("Activity Reminder",
        "Morning Football match tomorrow at 6:00 AM",
        "Feb 17, 8:00 AM", false, Icons.calendar_today, Color(0xFFFFF3D6), Color(0xFFF59E0B)),

    _Notif("New Message",
        "Khalid sent you a message",
        "Feb 16, 3:45 PM", true, Icons.chat_bubble_outline, Color(0xFFE6F0FF), Color(0xFF3B82F6)),

    _Notif("Group Created",
        'Your "Evening Running" group is now live!',
        "Feb 15, 12:00 PM", true, Icons.groups, Color(0xFFEDE9FE), Color(0xFF8B5CF6)),
  ];

  int get unreadCount => items.where((e) => !e.isRead).length;

  void markAllRead() {
    setState(() {
      for (var n in items) {
        n.isRead = true;
      }
    });
  }

  void _onNavTap(int i) {
    setState(() => _navIndex = i);

    switch (i) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.groups);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.search);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.addActivity);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Notifications",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Text("$unreadCount unread",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: markAllRead,
            child: const Text(
              "Mark all read",
              style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final n = items[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: n.isRead
                      ? Colors.transparent
                      : const Color(0xFFBFEFD9),
                  width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                // أيقونة دائرية
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: n.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(n.icon, color: n.iconColor),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(n.message,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(n.date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),

                // النقطة الخضراء لغير المقروء
                if (!n.isRead)
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFF10B981),
                  )
              ],
            ),
          );
        },
      ),

      // 🔥 نفس البوتوم ناف بالضبط
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: "Groups"),
          NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: "Create"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class _Notif {
  final String title;
  final String message;
  final String date;
  bool isRead;
  final IconData icon;
  final Color bg;
  final Color iconColor;

  _Notif(this.title, this.message, this.date, this.isRead, this.icon, this.bg,
      this.iconColor);
}
