import 'package:flutter/material.dart';
import 'otp_page.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  static const Color _primaryGreen = Color(0xFF19C58B);
  static const Color _lightGreen = Color(0xFFE8F7F1);
  static const Color _bgColor = Color(0xFFF5F7F9);
  static const Color _textDark = Color(0xFF1D2939);

  String _accountType = 'regular';

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bioController = TextEditingController();

  DateTime? _birthdate;
  int? _age;
  String? _gender;

  final List<String> _activities = [
    'Football',
    'Basketball',
    'Swimming',
    'Running',
    'Reading',
    'Gaming',
    'Photography',
    'Traveling',
    'Cooking',
    'Music',
    'Drawing',
  ];

  final List<String> _activityEmojis = [
    '⚽',
    '🏀',
    '🏊',
    '🏃',
    '📚',
    '🎮',
    '📸',
    '✈️',
    '🍳',
    '🎵',
    '🎨',
  ];

  final Set<String> _selectedActivities = {};
  final _otherActivityController = TextEditingController();
  bool _otherSelected = false;

  final _orgNameController = TextEditingController();
  final _orgEmailController = TextEditingController();
  final _orgPhoneController = TextEditingController();
  final _orgPasswordController = TextEditingController();
  final _orgDescController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    _otherActivityController.dispose();

    _orgNameController.dispose();
    _orgEmailController.dispose();
    _orgPhoneController.dispose();
    _orgPasswordController.dispose();
    _orgDescController.dispose();

    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      setState(() => _currentStep++);
      return;
    }

    if (_currentStep == 1) {
      final isValid =
          _accountType == 'regular'
              ? _validateUser()
              : _validateOrganization();

      if (!isValid) return;

      setState(() => _currentStep++);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OtpPage()),
    );
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          accountType:
              _accountType == 'organization'
                  ? 'organization'
                  : 'player',
        ),
      ),
    );
  }

  bool _validateUser() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    final usernameValid = RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

    if (_birthdate != null) {
      final today = DateTime.now();
      _age = today.year - _birthdate!.year;

      if (today.month < _birthdate!.month ||
          (today.month == _birthdate!.month &&
              today.day < _birthdate!.day)) {
        _age = _age! - 1;
      }
    }

    final ageValid = _age != null && _age! >= 18;

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      _error('Please fill all required fields');
      return false;
    }

    if (!usernameValid) {
      _error('Username must contain English letters, numbers, or _ only');
      return false;
    }

    if (!emailValid) {
      _error('Enter a valid email');
      return false;
    }

    if (!ageValid) {
      _error('You must be 18+');
      return false;
    }

    return true;
  }

  bool _validateOrganization() {
    final name = _orgNameController.text.trim();
    final email = _orgEmailController.text.trim();
    final phone = _orgPhoneController.text.trim();
    final password = _orgPasswordController.text.trim();

    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      _error('Please fill all required fields');
      return false;
    }

    if (!emailValid) {
      _error('Enter a valid email');
      return false;
    }

    return true;
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SingleChildScrollView(
                  key: ValueKey(_currentStep.toString() + _accountType),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      _buildMainCard(
                        child: _currentStep == 0
                            ? _step1()
                            : _currentStep == 1
                                ? (_accountType == 'regular'
                                    ? _userStep2()
                                    : _orgStep2())
                                : (_accountType == 'regular'
                                    ? _userStep3()
                                    : _orgStep3()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF19C58B), Color(0xFF119E6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _circleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: _prevStep,
              ),
              const Spacer(),
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _skip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _stepTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _stepSubtitle(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          _progress(),
        ],
      ),
    );
  }

  String _stepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Choose your account';
      case 1:
        return _accountType == 'regular'
            ? 'Your personal information'
            : 'Organization details';
      case 2:
        return 'Review & finish';
      default:
        return '';
    }
  }

  String _stepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Select the type of account you want to create';
      case 1:
        return 'Complete the required information to continue';
      case 2:
        return 'One last step before verification';
      default:
        return '';
    }
  }

  Widget _buildMainCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Account Type',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'You can register as a regular user or as an organization.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 24),
        _typeCard(
          value: 'regular',
          title: 'User',
          subtitle: 'Create a personal profile and join activities',
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 14),
        _typeCard(
          value: 'organization',
          title: 'Organization',
          subtitle: 'Manage events, teams, and participants',
          icon: Icons.business_rounded,
        ),
        const SizedBox(height: 28),
        _primaryButton(
          text: 'Continue',
          onTap: _nextStep,
        ),
      ],
    );
  }

  Widget _userStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _usernameController,
          label: 'Username',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _phoneController,
          label: 'Phone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 14),
        _dateField(),
        const SizedBox(height: 14),
        _genderSelector(),
        const SizedBox(height: 24),
        _primaryButton(
          text: 'Continue',
          onTap: _nextStep,
        ),
      ],
    );
  }

  Widget _userStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _heightController,
          label: 'Height (cm)',
          icon: Icons.height,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _weightController,
          label: 'Weight (kg)',
          icon: Icons.monitor_weight_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _bioController,
          label: 'Bio',
          icon: Icons.info_outline,
          maxLines: 3,
        ),
        const SizedBox(height: 18),
        const Text(
          'Preferred Activities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_activities.length, (index) {
            final activity = _activities[index];
            final selected = _selectedActivities.contains(activity);

            return FilterChip(
              label: Text(
                '${_activityEmojis[index]} $activity',
                style: TextStyle(
                  color: selected ? Colors.white : _textDark,
                ),
              ),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  if (selected) {
                    _selectedActivities.remove(activity);
                  } else {
                    _selectedActivities.add(activity);
                  }
                });
              },
              backgroundColor: const Color(0xFFFFFFFF),
              selectedColor: _primaryGreen,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: selected ? _primaryGreen : const Color(0xFFD0D5DD),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _otherSelected,
          onChanged: (value) {
            setState(() {
              _otherSelected = value ?? false;
              if (!_otherSelected) {
                _otherActivityController.clear();
              }
            });
          },
          activeColor: _primaryGreen,
          checkColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Other activity',
            style: TextStyle(color: _textDark),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (_otherSelected) ...[
          const SizedBox(height: 8),
          _inputField(
            controller: _otherActivityController,
            label: 'Write other activity',
            icon: Icons.edit_outlined,
          ),
        ],
        const SizedBox(height: 28),
        _primaryButton(
          text: 'Finish Registration',
          onTap: _nextStep,
        ),
      ],
    );
  }

  Widget _orgStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Organization Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _orgNameController,
          label: 'Organization Name',
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _orgEmailController,
          label: 'Organization Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _orgPhoneController,
          label: 'Phone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _orgPasswordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 24),
        _primaryButton(
          text: 'Continue',
          onTap: _nextStep,
        ),
      ],
    );
  }

  Widget _orgStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Organization',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _orgDescController,
          label: 'Description',
          icon: Icons.description_outlined,
          maxLines: 5,
        ),
        const SizedBox(height: 20),
        _reviewBox(
          title: 'Review',
          children: [
            _reviewRow('Name', _orgNameController.text),
            _reviewRow('Email', _orgEmailController.text),
            _reviewRow('Phone', _orgPhoneController.text),
          ],
        ),
        const SizedBox(height: 28),
        _primaryButton(
          text: 'Finish Registration',
          onTap: _nextStep,
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _progress() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }

  Widget _typeCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _accountType == value;

    return InkWell(
      onTap: () {
        setState(() {
          _accountType = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? _lightGreen : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _primaryGreen : const Color(0xFFD0D5DD),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected ? _primaryGreen : const Color(0xFFE8F7F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : _primaryGreen,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? _primaryGreen : const Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: _textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF667085)),
        prefixIcon: Icon(icon, color: _primaryGreen),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
        ),
      ),
    );
  }

  Widget _dateField() {
    return InkWell(
      onTap: _pickBirthdate,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: _primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _birthdate == null
                    ? 'Select birthdate'
                    : '${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}',
                style: TextStyle(
                  fontSize: 15,
                  color: _birthdate == null
                      ? const Color(0xFF667085)
                      : _textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderSelector() {
    final genders = ['Male', 'Female'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: genders.map((g) {
            final selected = _gender == g;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _gender = g;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: g == 'Male' ? 8 : 0,
                    left: g == 'Female' ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? _lightGreen : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? _primaryGreen : const Color(0xFFD0D5DD),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    g,
                    style: TextStyle(
                      color: selected ? _primaryGreen : _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _reviewBox({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _birthdate = picked;
      });
    }
  }
}
