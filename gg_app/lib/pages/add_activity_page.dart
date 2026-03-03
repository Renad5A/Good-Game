import 'package:flutter/material.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  String riskLevel = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Activity"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Activity Name
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Activity Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Activity Type
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: "Activity Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: "Football", child: Text("Football")),
                DropdownMenuItem(
                    value: "Padel", child: Text("Padel")),
                DropdownMenuItem(
                    value: "Running", child: Text("Running")),
              ],
              onChanged: (value) {},
            ),

            const SizedBox(height: 15),

            // Description
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Risk Level",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            RadioListTile(
              title: const Text("Low Risk"),
              value: "Low",
              groupValue: riskLevel,
              onChanged: (value) {
                setState(() {
                  riskLevel = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text("Medium Risk"),
              value: "Medium",
              groupValue: riskLevel,
              onChanged: (value) {
                setState(() {
                  riskLevel = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text("High Risk"),
              value: "High",
              groupValue: riskLevel,
              onChanged: (value) {
                setState(() {
                  riskLevel = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1FAF7A),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {},
                child: const Text("Create Activity"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
