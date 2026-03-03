import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // مبدئياً نخليها ثابتة (لاحقاً نربطها بالداتا)
  final String username = "Ahmed";
  final String bioLine = "Sports enthusiast | Always\nlooking for new adventures";
  final List<String> tags = const ["Football", "Running", "Hiking"];

  int _navIndex = 0;

  void _go(String route) {
    Navigator.pushNamed(context, route);
  }

  // تنقل البوتوم ناف حسب التصميم (Home/Groups/Search/Create/Profile)
  void _onNavTap(int i) {
    setState(() => _navIndex = i);

    switch (i) {
      case 0:
        // Home (انتِ فيها)
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
    // ألوان قريبة جداً من الصورة
    const headerGreen = Color(0xFF0FAE78);
    const headerGreenDark = Color(0xFF0B9C6C);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      // البودي كامل Scroll
      body: Stack(
        children: [
          // ===== الخلفية الخضراء العلوية (مثل الصورة) =====
          Container(
            height: 290,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [headerGreen, headerGreenDark],
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              children: [
                // ===== Top header: Welcome + اسم + ايقونات =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // يسار: النص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),

                    // يمين: جرس + شات (مثل الصورة)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _go(AppRoutes.notifications),
                          icon: const Icon(Icons.notifications_none_outlined),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () => _go(AppRoutes.chat),
                          icon: const Icon(Icons.chat_bubble_outline),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ===== كرت المستخدم (أبيض كبير) =====
                _ProfileCard(
                  username: username,
                  bioLine: bioLine,
                  tags: tags,
                  onTap: () => _go(AppRoutes.profile),
                ),

                const SizedBox(height: 18),

                // ===== 3 كروت: Groups / Search / Add (بنفس شكل البلوك الملون يسار) =====
                _ActionCard(
                  color: const Color(0xFF12B886), // أخضر
                  icon: Icons.groups_outlined,
                  title: "Groups",
                  subtitle: "View joined and created groups",
                  onTap: () => _go(AppRoutes.groups),
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  color: const Color(0xFF7C5CFF), // بنفسجي
                  icon: Icons.search,
                  title: "Search Activity",
                  subtitle: "Find activities near you",
                  onTap: () => _go(AppRoutes.search),
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  color: const Color(0xFFF59F00), // برتقالي
                  icon: Icons.add,
                  title: "Add Activity",
                  subtitle: "Create a personal activity",
                  onTap: () => _go(AppRoutes.addActivity),
                ),

                const SizedBox(height: 22),

                // ===== عنوان Your Activity =====
                const Text(
                  "Your Activity",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 14),

                // ===== كروت إحصائيات بسيطة تحت (مثل الصورة) =====
                Row(
                  children: const [
                    Expanded(
                      child: _StatCard(
                        number: "3",
                        label: "Groups",
                        accent: Color(0xFF12B886),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        number: "1",
                        label: "Groups",
                        accent: Color(0xFF7C5CFF),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        number: "5",
                        label: "Activities",
                        accent: Color(0xFFF59F00),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 90), // مساحة فوق البوتوم ناف
              ],
            ),
          ),
        ],
      ),

      // ===== Bottom Nav مثل الصورة =====
      bottomNavigationBar: _GGBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// ===== كرت البروفايل الأبيض =====
class _ProfileCard extends StatelessWidget {
  final String username;
  final String bioLine;
  final List<String> tags;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.username,
    required this.bioLine,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // دائرة الحرف
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF12B886), Color(0xFF0FAE78)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
                  ],
                ),
                child: Center(
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : "U",
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // نصوص + Tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bioLine,
                      style: const TextStyle(color: Color(0xFF6B7280), height: 1.15),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F8F2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                t,
                                style: const TextStyle(
                                  color: Color(0xFF0FAE78),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== كرت الأكشن (بلوك ملون يسار + كرت أبيض يمين) =====
class _ActionCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Stack(
        children: [
          // الكرت الأبيض
          Positioned.fill(
            left: 68,
            child: Card(
              elevation: 10,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // البلوك الملون يسار
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 86,
              height: 92,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== كرت الإحصائيات =====
class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color accent;

  const _StatCard({
    required this.number,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: accent),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}

/// ===== Bottom Nav مثل الصورة =====
class _GGBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GGBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // نستخدم NavigationBar (Material3) يعطي نفس روح التصميم
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: "Groups"),
        NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search), label: "Search"),
        NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: "Create"),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
