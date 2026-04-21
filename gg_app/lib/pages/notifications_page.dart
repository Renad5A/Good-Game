import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _navIndex = 0;

  final List<_Notif> items = [
    _Notif(
      "New Member Joined",
      'Faisal joined your "Evening Running" group',
      "Feb 17, 10:30 AM",
      false,
      Icons.group,
      const Color(0xFFE8F7F1),
      const Color(0xFF167C5A),
      AppRoutes.chat,
    ),
    _Notif(
      "New Message",
      "Khalid sent you a message",
      "Feb 16, 3:45 PM",
      true,
      Icons.chat_bubble_outline,
      const Color(0xFFEFF8F3),
      const Color(0xFF167C5A),
      AppRoutes.chat,
    ),
    _Notif(
      "Group Created",
      'Your "Evening Running" group is now live!',
      "Feb 15, 12:00 PM",
      true,
      Icons.groups,
      const Color(0xFFE8F7F1),
      const Color(0xFF167C5A),
      AppRoutes.chat,
    ),
  ];

  int get unreadCount => items.where((e) => !e.isRead).length;

  void markAllRead() {
    setState(() {
      for (var n in items) {
        n.isRead = true;
      }
    });
  }

  void _openNotification(_Notif n) {
    setState(() {
      n.isRead = true;
    });

    Navigator.pushNamed(context, n.route);
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
    const Color darkBlue = Color(0xFF1D2939);
    const Color pageBg = Color(0xFFF5F7F9);
    const Color textGrey = Color(0xFF667085);
    const Color navIconColor = Color(0xFF667085);

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
                        Color(0xFF19C58B),
                        Color(0xFF119E6A),
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
                        onTap: () => Navigator.pop(context),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Notifications",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$unreadCount unread",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: markAllRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Mark all read",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final n = items[i];

                      return GestureDetector(
                        onTap: () => _openNotification(n),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.80),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: n.isRead
                                  ? Colors.transparent
                                  : const Color(0xFFB7E8D4),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x149AA6B2),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: n.bg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  n.icon,
                                  color: n.iconColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            n.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: darkBlue,
                                            ),
                                          ),
                                        ),
                                        if (!n.isRead)
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF19C58B),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      n.message,
                                      style: const TextStyle(
                                        color: textGrey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      n.date,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
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
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7F9),
          border: Border(
            top: BorderSide(
              color: Color(0xFFE7E7E8),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomItem(
                icon: Icons.home,
                label: "Home",
                selected: _navIndex == 0,
                color: navIconColor,
                onTap: () => _onNavTap(0),
              ),
              _BottomItem(
                icon: Icons.groups,
                label: "Groups",
                selected: _navIndex == 1,
                color: navIconColor,
                onTap: () => _onNavTap(1),
              ),
              _BottomItem(
                icon: Icons.search,
                label: "Search",
                selected: _navIndex == 2,
                color: navIconColor,
                onTap: () => _onNavTap(2),
              ),
              _BottomItem(
                icon: Icons.add,
                label: "Create",
                selected: _navIndex == 3,
                color: navIconColor,
                onTap: () => _onNavTap(3),
              ),
              _BottomItem(
                icon: Icons.person,
                label: "Profile",
                selected: _navIndex == 4,
                color: navIconColor,
                onTap: () => _onNavTap(4),
              ),
            ],
          ),
        ),
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
  final String route;

  _Notif(
    this.title,
    this.message,
    this.date,
    this.isRead,
    this.icon,
    this.bg,
    this.iconColor,
    this.route,
  );
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE8F7F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: color,
                size: 31,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
