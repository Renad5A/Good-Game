import 'package:flutter/material.dart';
import 'skill_level_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, 
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B9B7E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
                  color: const Color(0xFF1B9B7E), 
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
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.green[400],
                      child: const Text('A', style: TextStyle(fontSize: 40, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            const Text('Ahmed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Member', style: TextStyle(color: Colors.grey)),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Sports enthusiast | Always looking for new adventures. Love meeting new people and staying active!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),

            _buildActionButtons(context),
            
            _buildSectionHeader('Favorite Activities'),
            _buildActivityChips(),

            _buildSectionHeader('Joined Groups (2)'),
            _buildGroupCard('Morning Football', 'by Khalid', '2/12', 'Football'),
            _buildGroupCard('Weekend Hikers', 'by Sara', '3/8', 'Hiking'),

            _buildSectionHeader('Created Groups (1)'),
            _buildGroupCard('Evening Running', 'by Ahmed (You)', '2/10', 'Running'),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _customButton(Icons.edit_outlined, 'Edit Profile', () {}),
        _customButton(Icons.emoji_events_outlined, 'Skill Level', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SkillLevelPage()));
        }),
      ],
    );
  }

  Widget _customButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.black87),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft, 
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
      ),
    );
  }

  Widget _buildActivityChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          _activityChip('Football • intermediate'),
          _activityChip('Running • beginner'),
          _activityChip('Hiking'),
        ],
      ),
    );
  }

  Widget _activityChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Color(0xFF1B9B7E), fontSize: 12)),
      backgroundColor: const Color(0xFFE8F5E9),
      side: BorderSide.none,
    );
  }

  Widget _buildGroupCard(String name, String creator, String count, String tag) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(creator),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
             _activityChip(tag),
             Text(count, style: const TextStyle(color: Color(0xFF1B9B7E), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
