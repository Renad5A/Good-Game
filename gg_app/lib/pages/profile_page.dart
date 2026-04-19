import 'package:flutter/material.dart';
import 'skill_level_page.dart';
import '../edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // تعريف لوحة الألوان الفخمة
  static const Color bgDark = Color(0xFF0F1214);      // الخلفية العميق
  static const Color surfaceDark = Color(0xFF1A1F23); // الحاويات والبطاقات
  static const Color accentGold = Color(0xFFD4AF37);  // الذهبي للأيقونات والتفاعل
  static const Color textMain = Color(0xFFE0E0E0);    // النص الأساسي

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
          unselectedItemColor: Colors.white38,
          showUnselectedLabels: true,
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
                // الغطاء العلوي بتدرج ذهبي خفيف
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
                            icon: const Icon(Icons.settings_outlined, color: textMain),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // الصورة الشخصية مع إطار ذهبي
                Positioned(
                  top: 110,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: accentGold,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: surfaceDark,
                      child: const Text('A', 
                        style: TextStyle(fontSize: 40, color: accentGold, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65),

            const Text('Ahmed', 
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)
            ),
            const Text('Member', style: TextStyle(color: accentGold, fontWeight: FontWeight.w500)),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                'Sports enthusiast | Always looking for new adventures. Love meeting new people and staying active!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _customButton(Icons.edit_outlined, 'Edit Profile', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
        }),
        const SizedBox(width: 12),
        _customButton(Icons.emoji_events_outlined, 'Skill Level', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SkillLevelPage()));
        }),
      ],
    );
  }

  Widget _customButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        child: Text(title, 
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accentGold, letterSpacing: 0.5)
        )
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
        color: surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentGold.withOpacity(0.3)),
      ),
      child: Text(label, style: const TextStyle(color: textMain, fontSize: 12)),
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
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(creator, style: const TextStyle(color: Colors.white38, fontSize: 13)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(tag, style: const TextStyle(color: accentGold, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(count, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
