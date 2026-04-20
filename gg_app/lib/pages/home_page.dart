import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class HomePage extends StatefulWidget {
  final String accountType;

  const HomePage({
    super.key,
    required this.accountType,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "Ahmed";
  final String organizationName = "Fit Club";

  int _navIndex = 0;

  void _go(String route) {
    Navigator.pushNamed(context, route);
  }

  void _onNavTap(int i) {
    setState(() => _navIndex = i);

    switch (i) {
      case 0:
        break;
      case 1:
        _go(AppRoutes.groups);
        break;
      case 2:
        _go(AppRoutes.search);
        break;
      case 3:
        _go(AppRoutes.addActivity);
        break;
      case 4:
        _go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color pageBg = Color(0xFFF3F4F6);
    const Color darkBlue = Color(0xFF213F73);
    const Color midBlue = Color(0xFF86B3EE);
    const Color lightBlue = Color(0xFFAED3EC);
    const Color cardColor = Color(0xFFF1F5F9);
    const Color navIconColor = Color(0xFF5A5561);

    final bool isOrganization = widget.accountType == 'organization';

    final String displayName = isOrganization ? organizationName : username;
    final String bioLine = isOrganization
        ? "Create activities | Manage members\nand grow your community"
        : "Sports enthusiast | Always\nlooking for new adventures";

    final String activityTitle =
        isOrganization ? "Organization Activity" : "Your Activity";

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 470,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(56),
                      bottomRight: Radius.circular(56),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [midBlue, lightBlue],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(color: pageBg),
                ),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Welcome\n$displayName",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _topIconButton(
                            icon: Icons.notifications,
                            onTap: () => _go(AppRoutes.notifications),
                          ),
                          const SizedBox(width: 14),
                          _topIconButton(
                            icon: Icons.chat_bubble,
                            onTap: () => _go(AppRoutes.chat),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF88B5EF),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : "A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            bioLine,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.35,
                              color: darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    "Quick Access",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 22),

                  isOrganization
                      ? Row(
                          children: [
                            Expanded(
                              child: _quickAccessCard(
                                icon: Icons.groups,
                                title: "Groups",
                                onTap: () => _go(AppRoutes.groups),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _quickAccessCard(
                                icon: Icons.add_circle,
                                title: "Activity",
                                onTap: () => _go(AppRoutes.addActivity),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _quickAccessCard(
                                icon: Icons.groups,
                                title: "Groups",
                                onTap: () => _go(AppRoutes.groups),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _quickAccessCard(
                                icon: Icons.search,
                                title: "Search",
                                onTap: () => _go(AppRoutes.search),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _quickAccessCard(
                                icon: Icons.add_circle,
                                title: "Activity",
                                onTap: () => _go(AppRoutes.addActivity),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 34),
                  Text(
                    activityTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: isOrganization
                        ? const [
                            Expanded(
                              child: _activityStatCard(
                                number: "8",
                                label: "Events",
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _activityStatCard(
                                number: "24",
                                label: "Members",
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _activityStatCard(
                                number: "12",
                                label: "Requests",
                              ),
                            ),
                          ]
                        : const [
                            Expanded(
                              child: _activityStatCard(
                                number: "3",
                                label: "Joined",
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _activityStatCard(
                                number: "1",
                                label: "Created",
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _activityStatCard(
                                number: "5",
                                label: "Total",
                              ),
                            ),
                          ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F7),
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
              _bottomItem(
                icon: Icons.home,
                label: "Home",
                selected: _navIndex == 0,
                color: navIconColor,
                onTap: () => _onNavTap(0),
              ),
              _bottomItem(
                icon: Icons.groups,
                label: "Groups",
                selected: _navIndex == 1,
                color: navIconColor,
                onTap: () => _onNavTap(1),
              ),
              _bottomItem(
                icon: Icons.search,
                label: "Search",
                selected: _navIndex == 2,
                color: navIconColor,
                onTap: () => _onNavTap(2),
              ),
              _bottomItem(
                icon: Icons.add,
                label: "Create",
                selected: _navIndex == 3,
                color: navIconColor,
                onTap: () => _onNavTap(3),
              ),
              _bottomItem(
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

  Widget _topIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.92),
          size: 28,
        ),
      ),
    );
  }

  Widget _quickAccessCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 194,
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA).withOpacity(0.72),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 42,
              color: const Color(0xFF23457D),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF23457D),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
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
                color: selected ? const Color(0xFFDCEBFA) : Colors.transparent,
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

class _activityStatCard extends StatelessWidget {
  final String number;
  final String label;

  const _activityStatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF23457D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2F2F35),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
