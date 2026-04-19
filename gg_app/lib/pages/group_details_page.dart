import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class GroupDetailsPage extends StatefulWidget {
  final dynamic group;

  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late dynamic _g;
  bool _isJoined = false;
  int _membersCount = 0;
  late List<String> _members;
  late List<String> _joinRequests;

  @override
  void initState() {
    super.initState();
    _g = widget.group;
    _isJoined = _readBool("isJoined", fallback: false);
    _members = _readMembers();
    _joinRequests = _readJoinRequests();
    _membersCount = _readInt("membersCount", fallback: _members.length);
  }

  bool _readBool(String key, {required bool fallback}) {
    try {
      if (_g is Map) return (_g[key] == true);
      final d = _g as dynamic;
      if (key == "isJoined") return (d.isJoined == true);
    } catch (_) {}
    return fallback;
  }

  bool _readIsOwner() {
    try {
      if (_g is Map) {
        return _g["isOwner"] == true;
      }
    } catch (_) {}
    return false;
  }

  int _readInt(String key, {required int fallback}) {
    try {
      if (_g is Map) {
        final v = _g[key];
        if (v is int) return v;
      } else {
        final d = _g as dynamic;
        if (key == "membersCount" && d.membersCount is int) {
          return d.membersCount as int;
        }
        if (key == "maxParticipants" && d.maxParticipants is int) {
          return d.maxParticipants as int;
        }
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
          return v.map((e) => e.toString()).toList();
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

  List<String> _readJoinRequests() {
    try {
      if (_g is Map) {
        final v = _g["joinRequests"];
        if (v is List) {
          return v.map((e) => e.toString()).toList();
        }
      } else {
        final d = _g as dynamic;
        final v = d.joinRequests;
        if (v is List) {
          return v.map((e) => e.toString()).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case "advanced 🔥":
        return const Color(0xFFE53935);
      case "intermediate ⚡️":
        return const Color(0xFFF9A825);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _levelIcon(String level) {
    switch (level.toLowerCase()) {
      case "advanced 🔥":
        return Icons.local_fire_department_rounded;
      case "intermediate ⚡️":
        return Icons.flash_on_rounded;
      default:
        return Icons.eco_rounded;
    }
  }

  String _fullEventMessage({
    required String name,
    required String activity,
    required String location,
    required String date,
    required String time,
    required String level,
    required String desc,
  }) {
    return "📌 Event Details\n"
        "• $name\n"
        "• $activity\n"
        "• $location\n"
        "• $date at $time\n\n"
        "✅ Notes:\n$desc\n\n"
        "⚠ Level: $level";
  }

  void _openReportSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Report",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
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

  void _acceptRequest(String user) {
    final maxParticipants = _readInt("maxParticipants", fallback: 0);

    if (maxParticipants > 0 && _membersCount >= maxParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group is full.")),
      );
      return;
    }

    setState(() {
      _joinRequests.remove(user);
      _members.add(user);
      _membersCount = _members.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$user accepted ✅")),
    );
  }

  void _rejectRequest(String user) {
    setState(() {
      _joinRequests.remove(user);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$user rejected ❌")),
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
    const Color pageBg = Color(0xFFF3F4F6);
    const Color darkBlue = Color(0xFF213F73);
    const Color midBlue = Color(0xFF86B3EE);
    const Color lightBlue = Color(0xFFAED3EC);

    final name = _readString("groupName", fallback: "Group");
    final activity = _readString("activityType", fallback: "Activity");
    final location = _readString("location", fallback: "-");
    final date = _readString("date", fallback: "-");
    final time = _readString("time", fallback: "-");
    final creator = _readString("creatorName", fallback: "-");
    final level = _readString("riskLevel", fallback: "Beginner 🌱");
    final desc = _readString(
      "description",
      fallback: "Please arrive on time and be respectful to all members.",
    );
    final maxParticipants = _readInt("maxParticipants", fallback: 0);
    final isOwner = _readIsOwner();
    final levelColor = _levelColor(level);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 300,
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
            ListView(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
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
                        "Group Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _topIconButton(
                      icon: Icons.flag_outlined,
                      onTap: _openReportSheet,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Pill(
                            text: activity,
                            bg: const Color(0xFFDDEBFB),
                            fg: darkBlue,
                          ),
                          _Pill(
                            text: "Level: $level",
                            bg: levelColor.withOpacity(0.15),
                            fg: levelColor,
                            icon: _levelIcon(level),
                          ),
                          _Pill(
                            text: "$_membersCount/$maxParticipants",
                            bg: const Color(0xFFEAF4FF),
                            fg: darkBlue,
                            icon: Icons.groups_2_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _infoRow(Icons.location_on_outlined, location),
                      const SizedBox(height: 10),
                      _infoRow(Icons.calendar_month_outlined, date),
                      const SizedBox(height: 10),
                      _infoRow(Icons.access_time_rounded, time),
                      const SizedBox(height: 14),
                      const Divider(color: Color(0xFFE3E8EF)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Created by $creator",
                              style: const TextStyle(
                                color: darkBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.profile),
                            icon: const Icon(
                              Icons.open_in_new_rounded,
                              size: 18,
                            ),
                            label: const Text("View Creator Profile"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Event Message",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _fullEventMessage(
                          name: name,
                          activity: activity,
                          location: location,
                          date: date,
                          time: time,
                          level: level,
                          desc: desc,
                        ),
                        style: const TextStyle(
                          height: 1.45,
                          color: darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOwner) ...[
                  const SizedBox(height: 18),
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Join Requests",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (_joinRequests.isEmpty)
                          const Text(
                            "No pending requests.",
                            style: TextStyle(
                              color: darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Column(
                            children: _joinRequests.map((user) {
                              final initial = user.isNotEmpty
                                  ? user.trim()[0].toUpperCase()
                                  : "?";

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6FAFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFFDDEBFB),
                                      child: Text(
                                        initial,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: darkBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        user,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: darkBlue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _rejectRequest(user),
                                      child: const Text("Reject"),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      onPressed: () => _acceptRequest(user),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: const Color(0xFF86B3EE),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text("Accept"),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Members",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_members.isEmpty)
                        const Text(
                          "No members yet.",
                          style: TextStyle(
                            color: darkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Column(
                          children: _members.map((memberName) {
                            final initial = memberName.isNotEmpty
                                ? memberName.trim()[0].toUpperCase()
                                : "?";

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFDDEBFB),
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: darkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              title: Text(
                                memberName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: darkBlue,
                                ),
                              ),
                              subtitle: const Text(
                                "Member",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _toggleJoin,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _isJoined
                              ? const Color(0xFFDDEBFB)
                              : const Color(0xFF86B3EE),
                          foregroundColor:
                              _isJoined ? darkBlue : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        child: Text(_isJoined ? "Joined (Tap to Leave)" : "Join"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.chat,
                            arguments: {
                              "chatType": "group",
                              "groupName": name,
                            },
                          );
                        },
                        icon: const Icon(Icons.forum_outlined),
                        label: const Text("Group Chat"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkBlue,
                          side: const BorderSide(color: Color(0xFFBFD5F4)),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
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

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF213F73), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF213F73),
              fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}