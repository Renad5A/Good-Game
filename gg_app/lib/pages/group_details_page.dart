 import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class GroupDetailsPage extends StatefulWidget {
  final dynamic group; // <-- IMPORTANT: accepts Group object OR Map

  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late dynamic _g;
  bool _isJoined = false;
  int _membersCount = 0;

  @override
  void initState() {
    super.initState();
    _g = widget.group;

    _isJoined = _readBool("isJoined", fallback: false);
    _membersCount = _readInt("membersCount", fallback: _readMembers().length);
  }

  // ---------- Safe readers (Map or Group object) ----------
  bool _readBool(String key, {required bool fallback}) {
    try {
      if (_g is Map) return (_g[key] == true);
      final d = _g as dynamic;
      if (key == "isJoined") return (d.isJoined == true);
    } catch (_) {}
    return fallback;
  }

  int _readInt(String key, {required int fallback}) {
    try {
      if (_g is Map) {
        final v = _g[key];
        if (v is int) return v;
      } else {
        final d = _g as dynamic;
        if (key == "membersCount" && d.membersCount is int) return d.membersCount as int;
        if (key == "maxParticipants" && d.maxParticipants is int) return d.maxParticipants as int;
      }
    } catch (_) {}
    return fallback;
  }

  String _readString(String key, {required String fallback}) {
    try {
      if (_g is Map) {
        final v = _g[key];
        if (v is String) return v;
      } else {
        final d = _g as dynamic;
        switch (key) {
          case "groupName":
            return (d.groupName ?? fallback).toString();
          case "activityType":
            return (d.activityType ?? fallback).toString();
          case "location":
            return (d.location ?? fallback).toString();
          case "date":
            return (d.date ?? fallback).toString();
          case "time":
            return (d.time ?? fallback).toString();
          case "creatorName":
            return (d.creatorName ?? fallback).toString();
          case "riskLevel":
            return (d.riskLevel ?? fallback).toString();
          case "description":
            return (d.description ?? fallback).toString();
        }
      }
    } catch (_) {}
    return fallback;
  }

  List<String> _readMembers() {
    try {
      if (_g is Map) {
        final v = _g["members"];
        if (v is List) {
          return v.map((e) {
            if (e is Map && e["name"] != null) return e["name"].toString();
            return e.toString();
          }).toList();
        }
      } else {
        final d = _g as dynamic;
        final v = d.members;
        if (v is List) {
          return v.map((e) => e.toString()).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  // ---------- UI helpers ----------
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

  String _fullEventMessage({
    required String name,
    required String activity,
    required String location,
    required String date,
    required String time,
    required String risk,
    required String desc,
  }) {
    return "📌 Event Details\n"
        "• $name\n"
        "• $activity\n"
        "• $location\n"
        "• $date at $time\n\n"
        "✅ Notes:\n$desc\n\n"
        "⚠ Risk Level: $risk";
  }

  void _openReportSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Report",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 14),
              _reportTile("Spam / Fake group"),
              _reportTile("Inappropriate content"),
              _reportTile("Unsafe activity"),
              _reportTile("Other"),
            ],
          ),
        );
      },
    );
  }

  Widget _reportTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.flag_outlined),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Report submitted: $title")),
        );
      },
    );
  }

  void _toggleJoin() {
    setState(() {
      final maxParticipants = _readInt("maxParticipants", fallback: 0);

      if (_isJoined) {
        _isJoined = false;
        if (_membersCount > 0) _membersCount -= 1;
      } else {
        if (maxParticipants > 0 && _membersCount >= maxParticipants) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Group is full.")),
          );
          return;
        }
        _isJoined = true;
        _membersCount += 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isJoined ? "Joined ✅" : "Left ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _readString("groupName", fallback: "Group");
    final activity = _readString("activityType", fallback: "Activity");
    final location = _readString("location", fallback: "-");
    final date = _readString("date", fallback: "-");
    final time = _readString("time", fallback: "-");
    final creator = _readString("creatorName", fallback: "-");
    final risk = _readString("riskLevel", fallback: "Low");
    final desc = _readString(
      "description",
      fallback: "Please arrive on time and be respectful to all members.",
    );

    final maxParticipants = _readInt("maxParticipants", fallback: 0);
    final members = _readMembers();

    final riskColor = _riskColor(risk);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF111827),
        title: const Text("Group Details",
            style: TextStyle(fontWeight: FontWeight.w900)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: "Report",
            onPressed: _openReportSheet,
            icon: const Icon(Icons.flag_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _Pill(
                      text: activity,
                      bg: const Color(0xFFE6FBF2),
                      fg: const Color(0xFF12B981),
                    ),
                    _Pill(
                      text: "Risk: $risk",
                      bg: riskColor.withOpacity(0.12),
                      fg: riskColor,
                      icon: Icons.warning_rounded,
                    ),
                    _Pill(
                      text: "$_membersCount/$maxParticipants",
                      bg: const Color(0xFFE8F7FF),
                      fg: const Color(0xFF0288D1),
                      icon: Icons.groups_2_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Info(icon: Icons.location_on_outlined, text: location),
                const SizedBox(height: 8),
                _Info(icon: Icons.calendar_month_outlined, text: date),
                const SizedBox(height: 8),
                _Info(icon: Icons.access_time_rounded, text: time),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE8EEF5)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 18, color: Colors.black45),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Created by $creator",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text("View Creator Profile"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Event Message",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF111827))),
                const SizedBox(height: 10),
                Text(
                  _fullEventMessage(
                    name: name,
                    activity: activity,
                    location: location,
                    date: date,
                    time: time,
                    risk: risk,
                    desc: desc,
                  ),
                  style: const TextStyle(
                    height: 1.35,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Members",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF111827))),
                const SizedBox(height: 12),
                if (members.isEmpty)
                  const Text("No members yet (mock).",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w700))
                else
                  Column(
                    children: members.map((name) {
                      final initial =
                          name.isNotEmpty ? name.trim()[0].toUpperCase() : "?";
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE6FBF2),
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Color(0xFF12B981),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        title: Text(name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: const Text("Member",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleJoin,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _isJoined
                        ? const Color(0xFFE8EEF5)
                        : const Color(0xFF12B981),
                    foregroundColor:
                        _isJoined ? const Color(0xFF111827) : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  child: Text(_isJoined ? "Joined (Tap to Leave)" : "Join"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.chat),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text("Message Creator"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFE8EEF5)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: child,
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black38, size: 22),
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

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  const _Pill({
    required this.text,
    required this.bg,
    required this.fg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Text(text,
              style: TextStyle(color: fg, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
