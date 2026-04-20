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
  final String accountType;

  const ProfilePage({
    super.key,
    this.accountType = 'player',
  });

  static const Color bgDark = Color(0xFF0F1214);
  static const Color surfaceDark = Color(0xFF1A1F23);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color textMain = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    final bool isOrganization = accountType == 'organization';

    return Scaffold(
      backgroundColor: bgDark,
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: surfaceDark),
        child: BottomNavigationBar(
          currentIndex: 4,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: accentGold,
          unselectedItemColor: Colors.white38,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(accountType: accountType),
                ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
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
                      colors: [Color(0xFF2C2C2C), surfaceDark],
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
                            icon: const Icon(Icons.arrow_back, color: textMain),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: textMain,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
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
                      child: Text(
                        isOrganization ? 'F' : 'A',
                        style: const TextStyle(
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
            Text(
              isOrganization ? 'Fit Club' : 'Ahmed',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            Text(
              isOrganization ? 'Organization' : 'Member',
              style: const TextStyle(
                color: accentGold,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                isOrganization
                    ? 'Create activities, manage members, and grow your sports community with ease.'
                    : 'Sports enthusiast | Always looking for new adventures. Love meeting new people and staying active!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildActionButtons(context, isOrganization),
            const SizedBox(height: 25),
            _buildSectionHeader('Favorite Activities'),
            _buildActivityChips(isOrganization),
            _buildSectionHeader(
              isOrganization ? 'Managed Groups (2)' : 'Joined Groups (2)',
            ),
            _buildGroupCard(
              isOrganization ? 'Football League' : 'Morning Football',
              isOrganization ? 'by Fit Club' : 'by Khalid',
              isOrganization ? '8/20' : '2/12',
              'Football',
            ),
            _buildGroupCard(
              isOrganization ? 'Mountain Hikers' : 'Weekend Hikers',
              isOrganization ? 'by Fit Club' : 'by Sara',
              isOrganization ? '5/15' : '3/8',
              'Hiking',
            ),
            _buildSectionHeader(
              isOrganization ? 'Created Activities (1)' : 'Created Groups (1)',
            ),
            _buildGroupCard(
              isOrganization ? 'Community Run' : 'Evening Running',
              isOrganization ? 'by Fit Club' : 'by Ahmed (You)',
              isOrganization ? '12/30' : '2/10',
              'Running',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isOrganization) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _customButton(Icons.edit_outlined, 'Edit Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfilePage(),
              ),
            );
          }),
          const SizedBox(width: 8),
          _customButton(Icons.emoji_events_outlined, 'Skill Level', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SkillLevelPage()),
            );
          }),
          if (isOrganization) ...[
            const SizedBox(width: 8),
            _customButton(Icons.admin_panel_settings_outlined, 'Admin', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPanelPage()),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _customButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
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
            color: accentGold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityChips(bool isOrganization) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: isOrganization
            ? [
                _activityChip('Football'),
                _activityChip('Running'),
                _activityChip('Hiking'),
              ]
            : [
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
        color: surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentGold.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: textMain, fontSize: 12),
      ),
    );
  }

  Widget _buildGroupCard(String name, String creator, String count, String tag) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          creator,
          style: const TextStyle(color: Colors.white38, fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tag,
              style: const TextStyle(
                color: accentGold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

