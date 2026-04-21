import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class Group {
  final String name;
  final String location;
  final String date;
  final String time;
  final String creator;
  final String activity;
  final List<String> members;
  final int maxParticipants;
  final String level;
  final String description;
  final List<String> joinRequests;

  const Group({
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.creator,
    required this.activity,
    required this.members,
    required this.maxParticipants,
    required this.level,
    required this.description,
    required this.joinRequests,
  });
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int _tabIndex = 0;

  static const List<Group> joined = <Group>[
    Group(
      name: "Morning Football",
      location: "Al Olaya, Riyadh",
      date: "Feb 20, 2026",
      time: "6:00 AM",
      creator: "Khalid",
      activity: "Football",
      members: ["Khalid", "Faisal"],
      maxParticipants: 12,
      level: "Intermediate ⚡️",
      description: "Friendly football match. Please arrive early.",
      joinRequests: ["Nasser"],
    ),
    Group(
      name: "Weekend Hikers",
      location: "Al Naseem, Riyadh",
      date: "Feb 22, 2026",
      time: "5:00 AM",
      creator: "Sara",
      activity: "Hiking",
      members: ["Sara", "Mona", "Lama"],
      maxParticipants: 8,
      level: "Advanced 🔥",
      description: "Mountain hiking activity for experienced members.",
      joinRequests: ["Huda", "Reem"],
    ),
    Group(
      name: "Tennis Club",
      location: "Al Malqa, Riyadh",
      date: "Feb 21, 2026",
      time: "7:00 PM",
      creator: "Ahmed",
      activity: "Tennis",
      members: ["Ahmed"],
      maxParticipants: 10,
      level: "Beginner 🌱",
      description: "Beginner-friendly tennis session.",
      joinRequests: [],
    ),
  ];

  static const List<Group> created = <Group>[
    Group(
      name: "Sunset Run",
      location: "Al Nakheel, Riyadh",
      date: "Mar 01, 2026",
      time: "5:15 PM",
      creator: "You",
      activity: "Running",
      members: ["You"],
      maxParticipants: 15,
      level: "Beginner 🌱",
      description: "Easy running session during sunset.",
      joinRequests: ["Sara", "Ahmed"],
    ),
  ];

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case "advanced 🔥":
        return const Color(0xFFE57373); // أحمر فاتح
      case "intermediate ⚡️":
        return const Color(0xFFFFB74D); // برتقالي فاتح
      default:
        return const Color(0xFF66BB6A); // أخضر فاتح
    }
  }

  String _levelEmoji(String level) {
    switch (level.toLowerCase()) {
      case "advanced 🔥":
        return "🔥";
      case "intermediate ⚡️":
        return "⚡️";
      default:
        return "🌱";
    }
  }

  String _levelText(String level) {
    if (level.toLowerCase().contains("advanced")) return "Advanced";
    if (level.toLowerCase().contains("intermediate")) return "Intermediate";
    return "Beginner";
  }

  @override
  Widget build(BuildContext context) {
    const Color pageBg = Color(0xFFF5F7F9);
    const Color darkBlue = Color(0xFF1D2939);
    const Color midBlue = Color(0xFF19C58B);
    const Color lightBlue = Color(0xFF119E6A);
    const Color cardColor = Color(0xFFFFFFFF);

    final List<Group> list = (_tabIndex == 0) ? joined : created;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 280,
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
                Expanded(child: Container(color: pageBg)),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _topIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "My Groups",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _segTab("Joined (${joined.length})", 0)),
                        const SizedBox(width: 8),
                        Expanded(child: _segTab("Created (${created.length})", 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final g = list[index];
                      final levelColor = _levelColor(g.level);

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.groupDetails,
                            arguments: {
                              "groupName": g.name,
                              "location": g.location,
                              "date": g.date,
                              "time": g.time,
                              "creatorName": g.creator,
                              "activityType": g.activity,
                              "members": g.members,
                              "membersCount": g.members.length,
                              "maxParticipants": g.maxParticipants,
                              "riskLevel": g.level,
                              "description": g.description,
                              "joinRequests": g.joinRequests,
                              "isOwner": _tabIndex == 1,
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      g.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: darkBlue,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F7F1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      g.activity,
                                      style: const TextStyle(
                                        color: Color(0xFF167C5A),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _infoRow(Icons.location_on_outlined, g.location),
                              const SizedBox(height: 10),
                              _infoRow(Icons.calendar_month_outlined, g.date),
                              const SizedBox(height: 10),
                              _infoRow(Icons.access_time_rounded, g.time),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFFE3E8EF)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF98A2B3),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "by ${g.creator}",
                                      style: const TextStyle(
                                        color: Color(0xFF667085),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _levelText(g.level),
                                    style: TextStyle(
                                      color: levelColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _levelEmoji(g.level),
                                    style: TextStyle(
                                      color: levelColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Icon(
                                    Icons.groups_2_outlined,
                                    size: 18,
                                    color: Color(0xFF19C58B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${g.members.length}/${g.maxParticipants}",
                                    style: const TextStyle(
                                      color: Color(0xFF19C58B),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              if (_tabIndex == 1 && g.joinRequests.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7F1),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    "Pending requests: ${g.joinRequests.length}",
                                    style: const TextStyle(
                                      color: Color(0xFF167C5A),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  Widget _segTab(String title, int index) {
    final selected = _tabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F7F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? const Color(0xFF167C5A) : const Color(0xFF667085),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon, size: 20, color: const Color(0xFF98A2B3)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
