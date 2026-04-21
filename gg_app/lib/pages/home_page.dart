import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class HomePage extends StatefulWidget {
  final String accountType;

  const HomePage({
    super.key,
    this.accountType = 'player',
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
    final bool isOrganization = widget.accountType == 'organization';

    const Color pageBg = Color(0xFFF5F7F9);
    const Color darkGreen = Color(0xFF119E6A);
    const Color mainGreen = Color(0xFF19C58B);
    const Color lightGreen = Color(0xFFE6F7F1);
    const Color cardColor = Color(0xFFFFFFFF);
    const Color navIconColor = Color(0xFF667085);
    const Color titleColor = Color(0xFF1D2939);
    const Color subtitleColor = Color(0xFF667085);

    final String displayName = isOrganization ? organizationName : username;
    final String bioLine = isOrganization
        ? "Create activities | Manage members\nand grow your community"
        : "Sports enthusiast | Always looking\nfor new adventures";

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
                  height: 330,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(48),
                      bottomRight: Radius.circular(48),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        mainGreen,
                        darkGreen,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(color: pageBg),
                ),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Welcome back\n",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                              TextSpan(
                                text: displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _topIconButton(
                            icon: Icons.notifications_none,
                            onTap: () => _go(AppRoutes.notifications),
                          ),
                          const SizedBox(width: 12),
                          _topIconButton(
                            icon: Icons.chat_bubble_outline,
                            onTap: () => _go(AppRoutes.chat),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [mainGreen, darkGreen],
                            ),
                            border: Border.all(
                              color: lightGreen,
                              width: 3,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : "A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                bioLine,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.35,
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (!isOrganization) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: const [
                                    _InterestChip(label: "Football"),
                                    _InterestChip(label: "Running"),
                                    _InterestChip(label: "Hiking"),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF98A2B3),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _actionRowCard(
                    color: mainGreen,
                    icon: Icons.groups_2_outlined,
                    title: "Groups",
                    subtitle: "View joined and created groups",
                    onTap: () => _go(AppRoutes.groups),
                  ),
                  const SizedBox(height: 2),
                  _actionRowCard(
                    color: const Color(0xFF8B5CF6),
                    icon: Icons.search,
                    title: "Search Activity",
                    subtitle: "Find activities near you",
                    onTap: () => _go(AppRoutes.search),
                  ),
                  const SizedBox(height: 2),
                  _actionRowCard(
                    color: const Color(0xFFF59E0B),
                    icon: Icons.add_circle_outline,
                    title: "Add Activity",
                    subtitle: "Create a personal activity",
                    onTap: () => _go(AppRoutes.addActivity),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    activityTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: isOrganization
                        ? const [
                            Expanded(
                              child: _ActivityStatCard(
                                number: "8",
                                label: "Events",
                                numberColor: Color(0xFF19C58B),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ActivityStatCard(
                                number: "24",
                                label: "Members",
                                numberColor: Color(0xFF8B5CF6),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ActivityStatCard(
                                number: "12",
                                label: "Requests",
                                numberColor: Color(0xFFF59E0B),
                              ),
                            ),
                          ]
                        : const [
                            Expanded(
                              child: _ActivityStatCard(
                                number: "3",
                                label: "Groups Joined",
                                numberColor: Color(0xFF19C58B),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ActivityStatCard(
                                number: "1",
                                label: "Groups",
                                numberColor: Color(0xFF8B5CF6),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ActivityStatCard(
                                number: "5",
                                label: "Activities",
                                numberColor: Color(0xFFF59E0B),
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
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFEAECEF),
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
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: "Home",
                selected: _navIndex == 0,
                activeColor: mainGreen,
                inactiveColor: navIconColor,
                onTap: () => _onNavTap(0),
              ),
              _bottomItem(
                icon: Icons.groups_2_outlined,
                activeIcon: Icons.groups,
                label: "Groups",
                selected: _navIndex == 1,
                activeColor: mainGreen,
                inactiveColor: navIconColor,
                onTap: () => _onNavTap(1),
              ),
              _bottomItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: "Search",
                selected: _navIndex == 2,
                activeColor: mainGreen,
                inactiveColor: navIconColor,
                onTap: () => _onNavTap(2),
              ),
              _bottomItem(
                icon: Icons.add_circle_outline,
                activeIcon: Icons.add_circle,
                label: "Create",
                selected: _navIndex == 3,
                activeColor: mainGreen,
                inactiveColor: navIconColor,
                onTap: () => _onNavTap(3),
              ),
              _bottomItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: "Profile",
                selected: _navIndex == 4,
                activeColor: const Color(0xFF344054),
                inactiveColor: navIconColor,
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _actionRowCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 104,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 84,
              height: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                color: Color(0xFFD0D5DD),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool selected,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE8F7F1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                selected ? activeIcon : icon,
                color: selected ? activeColor : inactiveColor,
                size: 27,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? activeColor : inactiveColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;

  const _InterestChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF167C5A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActivityStatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color numberColor;

  const _ActivityStatCard({
    required this.number,
    required this.label,
    required this.numberColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: numberColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
