import 'package:flutter/material.dart';

class SkillLevelPage extends StatefulWidget {
  const SkillLevelPage({super.key});

  @override
  State<SkillLevelPage> createState() => _SkillLevelPageState();
}

class _SkillLevelPageState extends State<SkillLevelPage> {
  // الألوان المعتمدة (نفس اللي استخدمناها في البروفايل والتعديل)
  static const Color bgDark = Color(0xFF0F1214);      // الخلفية
  static const Color surfaceDark = Color(0xFF1A1F23); // البطاقات
  static const Color accentGold = Color(0xFFD4AF37);  // الذهبي المطفأ
  static const Color textMain = Color(0xFFE0E0E0);    // النص الأساسي

  final List<Map<String, String>> activities = [
    {'name': 'Football', 'level': 'Intermediate'},
    {'name': 'Running', 'level': 'Beginner'},
    {'name': 'Tennis', 'level': 'Advanced'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text('Skill Levels', 
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 18)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: surfaceDark,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activities[index]['name']!,
                            style: const TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          // تعديل ستايل الـ Dropdown ليتناسب مع الخلفية الداكنة
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: surfaceDark,
                              iconEnabledColor: accentGold,
                              value: activities[index]['level'],
                              style: const TextStyle(color: accentGold, fontWeight: FontWeight.bold),
                              items: <String>['Beginner', 'Intermediate', 'Advanced']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  activities[index]['level'] = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // زر الحفظ بتدرج ذهبي
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: [accentGold, Color(0xFFB8860B)]),
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes saved successfully!', style: TextStyle(color: Colors.black)),
                      backgroundColor: accentGold,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('SAVE CHANGES', 
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
