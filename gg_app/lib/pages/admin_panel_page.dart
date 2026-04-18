import 'package:flutter/material.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  static const Color _green = Color(0xFF1B9B7E);

  final List<Map<String, dynamic>> _users = [
    {'name': 'Ahmed', 'email': 'ahmed@email.com', 'role': 'admin', 'status': 'active'},
    {'name': 'Sara', 'email': 'sara@email.com', 'role': 'member', 'status': 'active'},
    {'name': 'Khalid', 'email': 'khalid@email.com', 'role': 'member', 'status': 'suspended'},
    {'name': 'Mona', 'email': 'mona@email.com', 'role': 'member', 'status': 'active'},
  ];

  final List<Map<String, dynamic>> _groups = [
    {'name': 'Morning Football', 'type': 'Football', 'location': 'Al Olaya, Riyadh', 'members': '2/12', 'risk': 'Medium'},
    {'name': 'Weekend Hikers', 'type': 'Hiking', 'location': 'Al Naseem, Riyadh', 'members': '3/8', 'risk': 'High'},
    {'name': 'Tennis Club', 'type': 'Tennis', 'location': 'Al Malqa, Riyadh', 'members': '1/10', 'risk': 'Low'},
  ];

  final List<Map<String, dynamic>> _reports = [
    {'reporter': 'Sara', 'reason': 'Inappropriate content', 'targetType': 'Group', 'target': 'Morning Football', 'time': '2h ago'},
    {'reporter': 'Mona', 'reason': 'Spam messages', 'targetType': 'User', 'target': 'Khalid', 'time': '5h ago'},
    {'reporter': 'Ahmed', 'reason': 'Dangerous activity', 'targetType': 'Group', 'target': 'Weekend Hikers', 'time': '1d ago'},
  ];

  void _showUserOptions(BuildContext context, int index) {
    final user = _users[index];
    final isSuspended = user['status'] == 'suspended';
    final isAdmin = user['role'] == 'admin';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: _green.withOpacity(0.1),
                child: Text(user['name'][0], style: const TextStyle(color: _green, fontWeight: FontWeight.bold)),
              ),
              title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user['email']),
            ),
            const Divider(),
            ListTile(
              leading: Icon(isAdmin ? Icons.person : Icons.shield, color: _green),
              title: Text(isAdmin ? 'Remove Admin' : 'Make Admin'),
              onTap: () {
                setState(() => _users[index]['role'] = isAdmin ? 'member' : 'admin');
                Navigator.pop(ctx);
                _showSnack(context, isAdmin ? 'Removed admin role' : 'User is now admin');
              },
            ),
            ListTile(
              leading: Icon(isSuspended ? Icons.check_circle : Icons.block,
                  color: isSuspended ? _green : Colors.orange),
              title: Text(isSuspended ? 'Unsuspend User' : 'Suspend User'),
              onTap: () {
                setState(() => _users[index]['status'] = isSuspended ? 'active' : 'suspended');
                Navigator.pop(ctx);
                _showSnack(context, isSuspended ? 'User unsuspended' : 'User suspended');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete User', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, () => setState(() => _users.removeAt(index)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline, color: Color(0xFF1B9B7E)),
              title: const Text('Feature Group'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnack(context, 'Group featured ⭐');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Group', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, () => setState(() => _groups.removeAt(index)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () { Navigator.pop(ctx); onConfirm(); },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, backgroundColor: _green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: 'Users'),
              Tab(icon: Icon(Icons.group_outlined), text: 'Groups'),
              Tab(icon: Icon(Icons.flag_outlined), text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersTab(),
            _buildGroupsTab(),
            _buildReportsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard('Users', '${_users.length}', Icons.people_outline, _green),
          const SizedBox(width: 12),
          _statCard('Groups', '${_groups.length}', Icons.group_outlined, Colors.orange),
          const SizedBox(width: 12),
          _statCard('Reports', '${_reports.length}', Icons.flag_outlined, Colors.red),
        ],
      ),
    );
  }

  Widget _statCard(String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════
  // TAB 1: USERS
  // ══════════════════════════════
  Widget _buildUsersTab() {
    return Column(
      children: [
        _buildStatsRow(),
        Expanded(
          child: _users.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
                    final user = _users[i];
                    final isSuspended = user['status'] == 'suspended';
                    final isAdmin = user['role'] == 'admin';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: _green.withOpacity(0.1),
                          child: Text(user['name'][0], style: const TextStyle(color: _green, fontWeight: FontWeight.bold)),
                        ),
                        title: Row(
                          children: [
                            Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            if (isAdmin)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: _green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                child: const Text('Admin', style: TextStyle(fontSize: 10, color: _green, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email'], style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSuspended ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isSuspended ? 'Suspended' : 'Active',
                                style: TextStyle(fontSize: 11, color: isSuspended ? Colors.red : Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showUserOptions(context, i),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ══════════════════════════════
  // TAB 2: GROUPS
  // ══════════════════════════════
  Widget _buildGroupsTab() {
    if (_groups.isEmpty) return const Center(child: Text('No groups found'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _groups.length,
      itemBuilder: (context, i) {
        final group = _groups[i];
        final riskColor = group['risk'] == 'High'
            ? Colors.red
            : group['risk'] == 'Medium'
                ? Colors.orange
                : Colors.green;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: _green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.group_outlined, color: _green),
            ),
            title: Text(group['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(group['location'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: _green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(group['type'], style: const TextStyle(fontSize: 11, color: _green)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: riskColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text('${group['risk']} Risk', style: TextStyle(fontSize: 11, color: riskColor)),
                    ),
                    const Spacer(),
                    Text(group['members'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _green)),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showGroupOptions(context, i),
            ),
          ),
        );
      },
    );
  }

  // ══════════════════════════════
  // TAB 3: REPORTS
  // ══════════════════════════════
  Widget _buildReportsTab() {
    if (_reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: _green.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, color: _green, size: 60),
            ),
            const SizedBox(height: 16),
            const Text('All clear!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('No pending reports', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      itemBuilder: (context, i) {
        final report = _reports[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            border: Border.all(color: Colors.red.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.flag, color: Colors.red, size: 14),
                          const SizedBox(width: 4),
                          Text(report['targetType'], style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(report['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                // ── السبب ──
                Text(report['reason'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                // ── المبلّغ عنه ──
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Target: ${report['target']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                // ── اسم المبلّغ ──
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Reported by: ${report['reporter']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                // ── الأزرار ──
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _confirmDelete(context, () => setState(() => _reports.removeAt(i))),
                        child: const Text('Dismiss', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => setState(() => _reports.removeAt(i)),
                        child: const Text('Resolve'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
