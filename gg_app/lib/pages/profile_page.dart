import 'package:flutter/material.dart';
import 'skill_level_page.dart';
import 'edit_profile_page.dart';
import 'home_page.dart';
import 'groups_page.dart';
import 'search_page.dart';
import 'add_activity_page.dart';
import 'settings_page.dart';
import 'admin_panel_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color bgDark = Color(0xFFF5F7F9);
  static const Color surfaceDark = Color(0xFFFFFFFF);
  static const Color accentGold = Color(0xFF19C58B);
  static const Color textMain = Color(0xFF1D2939);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: surfaceDark),
        child: BottomNavigationBar(
          currentIndex: 4,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: accentGold,
          unselectedItemColor: const Color(0xFF98A2B3),
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GroupsPage()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddActivityPage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Groups'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF19C58B), Color(0xFF119E6A)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: accentGold,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: surfaceDark,
                      child: const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 40,
                          color: accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65),
            const Text(
              'Ahmed',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textMain,
                letterSpacing: 1,
              ),
            ),
            const Text(
              'Member',
              style: TextStyle(
                color: Color(0xFF19C58B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                'Sports enthusiast | Always looking for new adventures. Love meeting new people and staying active!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildActionButtons(context),
            const SizedBox(height: 25),
            _buildSectionHeader('Favorite Activities'),
            _buildActivityChips(),
            _buildSectionHeader('Joined Groups (2)'),
            _buildGroupCard('Morning Football', 'by Khalid', '2/12', 'Football'),
            _buildGroupCard('Weekend Hikers', 'by Sara', '3/8', 'Hiking'),
            _buildSectionHeader('Created Groups (1)'),
            _buildGroupCard('Evening Running', 'by Ahmed (You)', '2/10', 'Running'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _customButton(Icons.edit_outlined, 'Edit Profile', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
          }),
          const SizedBox(width: 8),
          _customButton(Icons.emoji_events_outlined, 'Skill Level', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SkillLevelPage()));
          }),
          const SizedBox(width: 8),
          _customButton(Icons.admin_panel_settings_outlined, 'Admin', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanelPage()));
          }),
        ],
      ),
    );
  }

  Widget _customButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF167C5A),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _activityChip('Football • Intermediate'),
          _activityChip('Running • Beginner'),
          _activityChip('Hiking'),
        ],
      ),
    );
  }

  Widget _activityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF19C58B).withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF344054),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGroupCard(String name, String creator, String count, String tag) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          name,
          style: const TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          creator,
          style: const TextStyle(
            color: Color(0xFF667085),
            fontSize: 13,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tag,
              style: const TextStyle(
                color: Color(0xFF19C58B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
