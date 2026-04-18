import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  // لوحة ألوان فخمة (Premium Dark Palette)
  static const Color bgDark = Color(0xFF0F1214);      // خلفية عميقة
  static const Color surfaceDark = Color(0xFF1A1F23); // لون الحقول والبطاقات
  static const Color accentGold = Color(0xFFD4AF37);  // ذهبي مطفأ للأيقونات والتفاعل
  static const Color textMain = Color(0xFFE0E0E0);    // نص أبيض ناعم

  final TextEditingController _nameController = TextEditingController(text: "Ahmed");
  final TextEditingController _usernameController = TextEditingController(text: "ggg");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otherActivityController = TextEditingController();

  DateTime? _selectedDate;
  final List<String> _activities = [
    '⚽ Football', '🏀 Basketball', '🏊 Swimming', 
    '🏃 Running', '📚 Reading', '🎮 Gaming', 
    '📷 Photography', '✈️ Traveling', '🍳 Cooking', 
    '🎵 Music', '🎨 Drawing'
  ];
  final List<String> _selectedActivities = ['⚽ Football', '🎮 Gaming'];
  bool _showOtherActivityField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: textMain, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Personal Information"),
            const SizedBox(height: 20),
            
            _buildInputField(_nameController, "Full Name", Icons.person_outline),
            _buildInputField(_usernameController, "Username", Icons.alternate_email),
            _buildInputField(_emailController, "Email", Icons.mail_outline),
            _buildInputField(_phoneController, "Phone Number", Icons.phone_android_outlined),

            const SizedBox(height: 25),
            _sectionTitle("Birthdate"),
            const SizedBox(height: 12),
            _buildDatePicker(),

            const SizedBox(height: 30),
            _sectionTitle("Preferred Activities"),
            const SizedBox(height: 15),
            _buildActivitiesWrap(),

            const SizedBox(height: 15),
            _buildOtherActivityToggle(),
            
            if (_showOtherActivityField)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: _buildInputField(_otherActivityController, "Enter activity", Icons.star_border),
              ),

            const SizedBox(height: 50),
            _buildSaveButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ويدجت عنوان القسم
  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(color: accentGold, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5));
  }

  // تصميم الحقول المرتب
  Widget _buildInputField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(icon, color: accentGold, size: 22),
          filled: true,
          fillColor: surfaceDark,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: accentGold, width: 1)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  // تصميم اختيار التاريخ
  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(color: surfaceDark, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: accentGold, size: 20),
            const SizedBox(width: 15),
            Text(
              _selectedDate == null ? "Select your birthdate" : DateFormat('yyyy - MM - dd').format(_selectedDate!),
              style: TextStyle(color: _selectedDate == null ? Colors.white38 : Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // تصميم الهوايات (Chips)
  Widget _buildActivitiesWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _activities.map((activity) {
        bool selected = _selectedActivities.contains(activity);
        return FilterChip(
          label: Text(activity, style: TextStyle(color: selected ? Colors.black : textMain, fontSize: 13)),
          selected: selected,
          onSelected: (bool val) {
            setState(() { val ? _selectedActivities.add(activity) : _selectedActivities.remove(activity); });
          },
          backgroundColor: surfaceDark,
          selectedColor: accentGold,
          checkmarkColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildOtherActivityToggle() {
    return Row(
      children: [
        SizedBox(
          height: 24, width: 24,
          child: Checkbox(
            value: _showOtherActivityField,
            activeColor: accentGold,
            checkColor: Colors.black,
            onChanged: (val) => setState(() => _showOtherActivityField = val!),
            side: const BorderSide(color: accentGold),
          ),
        ),
        const SizedBox(width: 10),
        const Text("I have other activities", style: TextStyle(color: textMain, fontSize: 14)),
      ],
    );
  }

  // زر الحفظ الفخم
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [accentGold, Color(0xFFB8860B)]), // تدرج ذهبي
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text("SAVE CHANGES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }
}
