import 'package:flutter/material.dart';

class SkillLevelPage extends StatefulWidget {
  const SkillLevelPage({super.key});

  @override
  State<SkillLevelPage> createState() => _SkillLevelPageState();
}

class _SkillLevelPageState extends State<SkillLevelPage> {
  static const Color pageBg = Color(0xFFF5F7F9);
  static const Color cardColor = Colors.white;
  static const Color mainGreen = Color(0xFF19C58B);
  static const Color textDark = Color(0xFF1D2939);

  final List<Map<String, String>> activities = [
    {'name': 'Football', 'level': 'Intermediate'},
    {'name': 'Running', 'level': 'Beginner'},
    {'name': 'Tennis', 'level': 'Advanced'},
  ];

  // 🎨 ألوان فاتحة
  Color _levelColor(String level) {
    switch (level) {
      case "Advanced":
        return const Color(0xFFE57373); // أحمر فاتح
      case "Intermediate":
        return const Color(0xFFFFB74D); // برتقالي فاتح
      default:
        return const Color(0xFF66BB6A); // أخضر فاتح
    }
  }

  // 🔥 أيقونات
  IconData _levelIcon(String level) {
    switch (level) {
      case "Advanced":
        return Icons.local_fire_department_rounded;
      case "Intermediate":
        return Icons.flash_on_rounded;
      default:
        return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text(
          'Skill Levels',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final level = activities[index]['level']!;
                  final color = _levelColor(level);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activities[index]['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),

                        // ✅ Dropdown مع أيقونة يمين
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: level,
                            icon: Icon(Icons.keyboard_arrow_down, color: color),
                            dropdownColor: Colors.white,
                            items: ['Beginner', 'Intermediate', 'Advanced']
                                .map((value) {
                              final c = _levelColor(value);

                              return DropdownMenuItem(
                                value: value,
                                child: Row(
                                  children: [
                                    Text(
                                      value,
                                      style: TextStyle(
                                        color: c,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(_levelIcon(value), size: 16, color: c),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                activities[index]['level'] = newValue!;
                              });
                            },

                            // 👇 شكل pill
                            selectedItemBuilder: (context) {
                              return ['Beginner', 'Intermediate', 'Advanced']
                                  .map((value) {
                                final c = _levelColor(value);

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: c.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        value,
                                        style: TextStyle(
                                          color: c,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(_levelIcon(value),
                                          size: 14, color: c),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // زر الحفظ
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [mainGreen, Color(0xFF119E6A)],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes saved successfully!'),
                      backgroundColor: mainGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'SAVE CHANGES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
