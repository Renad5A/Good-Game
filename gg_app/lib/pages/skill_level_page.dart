import 'package:flutter/material.dart';

class SkillLevelPage extends StatefulWidget {
  const SkillLevelPage({super.key});

  @override
  State<SkillLevelPage> createState() => _SkillLevelPageState();
}

class _SkillLevelPageState extends State<SkillLevelPage> {

  final List<Map<String, String>> activities = [
    {'name': 'Football', 'level': 'Intermediate'},
    {'name': 'Running', 'level': 'Beginner'},
    {'name': 'Tennis', 'level': 'Advanced'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Levels'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activities[index]['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          DropdownButton<String>(
                            value: activities[index]['level'],
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved successfully!'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
