import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class Group {
  final String name;
  final String location;
  final String date;
  final String time;
  final String creator;
  final String activity;
  final String members;
  final String risk; // Low / Medium / High

  const Group({
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.creator,
    required this.activity,
    required this.members,
    required this.risk,
  });
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int _tabIndex = 0;

  // ثابتة لتفادي مشاكل web
  static const List<Group> joined = <Group>[
    Group(
      name: "Morning Football",
      location: "Al Olaya, Riyadh",
      date: "Feb 20, 2026",
      time: "6:00 AM",
      creator: "Khalid",
      activity: "Football",
      members: "2/12",
      risk: "Medium",
    ),
    Group(
      name: "Weekend Hikers",
      location: "Al Naseem, Riyadh",
      date: "Feb 22, 2026",
      time: "5:00 AM",
      creator: "Sara",
      activity: "Hiking",
      members: "3/8",
      risk: "High",
    ),
    Group(
      name: "Tennis Club",
      location: "Al Malqa, Riyadh",
      date: "Feb 21, 2026",
      time: "7:00 PM",
      creator: "Ahmed",
      activity: "Tennis",
      members: "1/10",
      risk: "Low",
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
      members: "1/15",
      risk: "Low",
    ),
  ];

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case "high":
        return const Color(0xFFE53935);
      case "medium":
        return const Color(0xFFF9A825);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _riskIcon(String risk) {
    switch (risk.toLowerCase()) {
      case "high":
        return Icons.report_gmailerrorred_rounded;
      case "medium":
        return Icons.warning_amber_rounded;
      default:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Group> list = (_tabIndex == 0) ? joined : created;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "My Groups",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: const BackButton(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Create (prototype)")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF12B981),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Create",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(child: _segTab("Joined (3)", 0)),
                Expanded(child: _segTab("Created (1)", 1)),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final g = list[index];
                final riskColor = _riskColor(g.risk);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.groupDetails,
                      arguments: g, // مهم لـ main.dart as Group
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6FBF2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                g.activity,
                                style: const TextStyle(
                                  color: Color(0xFF12B981),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow(Icons.location_on_outlined, g.location),
                        const SizedBox(height: 8),
                        _infoRow(Icons.calendar_month_outlined, g.date),
                        const SizedBox(height: 8),
                        _infoRow(Icons.access_time_rounded, g.time),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE8EEF5)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                size: 18, color: Colors.black45),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "by ${g.creator}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Icon(_riskIcon(g.risk),
                                size: 18, color: riskColor),
                            const SizedBox(width: 6),
                            Text(
                              g.risk,
                              style: TextStyle(
                                color: riskColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Icon(Icons.groups_2_outlined,
                                size: 18, color: Color(0xFF12B981)),
                            const SizedBox(width: 6),
                            Text(
                              g.members,
                              style: const TextStyle(
                                color: Color(0xFF12B981),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _segTab(String title, int index) {
    final selected = _tabIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: selected ? const Color(0xFF111827) : Colors.black45,
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black38),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
