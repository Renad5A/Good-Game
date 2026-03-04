import 'package:flutter/material.dart';
import 'otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  static const Color _primaryGreen = Color(0xFF2DBD6E);

  // Step 1
  String _accountType = 'regular';
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _birthdate;

  // Step 2
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender;

  // Step 3
  final List<String> _activities = [
    'Football', 'Basketball', 'Swimming', 'Running'
  ];
  final List<String> _activityEmojis = ['⚽', '🏀', '🏊', '🏃'];
  final Set<String> _selectedActivities = {};
  bool _otherSelected = false;
  final _otherActivityController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _otherActivityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OtpPage()),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _currentStep == 0
                    ? _buildStep1()
                    : _currentStep == 1
                        ? _buildStep2()
                        : _buildStep3(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i <= _currentStep ? _primaryGreen : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ───────────────────────── STEP 1 ─────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Step 1 of 3',
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        const Text('Account Type & Basic Info',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text("Let's get started with the basics",
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 24),
        const Text('Account Type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        _buildAccountTypeCard(
          value: 'regular',
          title: 'Regular User',
          subtitle: 'Join and create personal activities',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 10),
        _buildAccountTypeCard(
          value: 'organization',
          title: 'Organization / Club',
          subtitle: 'Host official events, manage members',
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 20),
        _buildLabel('Username'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _usernameController,
            hint: 'Choose a username',
            prefixIcon: Icons.alternate_email),
        const SizedBox(height: 16),
        _buildLabel('Email'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _emailController,
            hint: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildLabel('Password'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _passwordController,
            hint: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscure: true),
        const SizedBox(height: 16),
        _buildLabel('Birthdate'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(primary: _primaryGreen),
                ),
                child: child!,
              ),
            );
            if (picked != null) setState(() => _birthdate = picked);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F6),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  _birthdate == null
                      ? 'يوس/رهش/سكع'
                      : '${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}',
                  style: TextStyle(
                    color: _birthdate == null ? Colors.grey : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _buildContinueButton('Continue →', _nextStep),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAccountTypeCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _accountType == value;
    return GestureDetector(
      onTap: () => setState(() => _accountType = value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? _primaryGreen : const Color(0xFFE0E0E0),
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: selected ? const Color(0xFFECFBF3) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _accountType,
              onChanged: (v) => setState(() => _accountType = v!),
              activeColor: _primaryGreen,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFD0F4E2)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: selected ? _primaryGreen : Colors.grey, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: selected ? _primaryGreen : Colors.black,
                    )),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── STEP 2 ─────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Step 2 of 3',
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        const Text('Body Information',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Help us personalize your experience',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 28),
        _buildLabel('Height (cm)'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _heightController,
          hint: 'e.g. 175',
          prefixIcon: Icons.straighten_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildLabel('Weight (kg)'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _weightController,
          hint: 'e.g. 70',
          prefixIcon: Icons.monitor_weight_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildLabel('Gender'),
        const SizedBox(height: 12),
        Row(
          children: ['Male', 'Female'].map((g) {
            final sel = _gender == g;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _gender = g),
                child: Container(
                  height: 48,
                  margin: EdgeInsets.only(right: g == 'Male' ? 12 : 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: sel ? _primaryGreen : const Color(0xFFE0E0E0),
                      width: sel ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: sel ? const Color(0xFFECFBF3) : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      g,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: sel ? _primaryGreen : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: _buildBackButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildContinueButton('Continue →', _nextStep)),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ───────────────────────── STEP 3 ─────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Step 3 of 3',
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        const Text('Favorite Activities',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Select all that interest you',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 20),
        // 4 activity cards in 2x2 grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
          ),
          itemCount: _activities.length,
          itemBuilder: (_, i) {
            final name = _activities[i];
            final sel = _selectedActivities.contains(name);
            return GestureDetector(
              onTap: () => setState(() => sel
                  ? _selectedActivities.remove(name)
                  : _selectedActivities.add(name)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: sel ? _primaryGreen : const Color(0xFFE0E0E0),
                    width: sel ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: sel ? const Color(0xFFECFBF3) : Colors.white,
                ),
                child: Row(
                  children: [
                    Text(_activityEmojis[i], style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sel ? _primaryGreen : Colors.black87,
                        )),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Other card
        GestureDetector(
          onTap: () => setState(() => _otherSelected = !_otherSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _otherSelected ? _primaryGreen : const Color(0xFFE0E0E0),
                width: _otherSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _otherSelected ? const Color(0xFFECFBF3) : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏅', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'Other',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _otherSelected ? _primaryGreen : Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (_otherSelected) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {}, // prevent parent tap
                    child: TextField(
                      controller: _otherActivityController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Type your sport...',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: _primaryGreen, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('Bio ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text('(optional)',
                style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 200,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Tell others a little about yourself...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              counterStyle: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildBackButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildContinueButton('Create Account', _nextStep)),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ───────────────────────── Helpers ─────────────────────────
  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildContinueButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: _prevStep,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('← Back',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
