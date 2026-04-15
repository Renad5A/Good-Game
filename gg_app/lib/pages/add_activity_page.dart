import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  static const Color primaryColor = Color(0xFF19C58B);
  static const Color pageBg = Color(0xFFF5F7F9);
  static const Color titleColor = Color(0xFF1D2740);
  static const Color shadowColor = Color(0x14000000);
  static const Color subtitleColor = Color(0xFF667085);
  static const Color borderColor = Color(0xFFD9DDE3);
  static const Color selectedBorderColor = Color(0xFF66D5AF);
  static const Color sectionIconGreen = Color(0xFF2DB783);
  static const Color sectionIconOrange = Color(0xFFE9A93B);
  static const Color sectionIconPurple = Color(0xFF8D67F7);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _googleMapsLinkController = TextEditingController();
  final TextEditingController _feesController = TextEditingController(text: '0');
  final TextEditingController _maxParticipantsController =
      TextEditingController(text: '20');

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSubscription;

  bool showMapPicker = false;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 11,
  );

  LatLng? _userLocation;
  LatLng? _selectedLocation;

  String? selectedActivityType;
  String? selectedNeighborhood;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String riskLevel = 'Low Risk';
  String createAs = 'Regular User';
  String genderPreference = 'Mixed';
  String activityMode = 'One-time Event';
  String? recurringFrequency;

  final List<String> neighborhoods = [
    "Al Olaya",
    "Al Malaz",
    "Al Nakheel",
    "Al Muruj",
    "Al Yasmin",
    "Al Rawdah",
    "Al Wurud",
    "Al Sahafah",
    "Al Narjis",
    "Al Aqiq",
    "King Abdullah District",
    "Al Nadwa",
    "Al Nadhim",
    "Al Rimal",
    "Ishbiliyah",
    "Hittin",
    "Qurtubah",
    "Al Munsiyah",
    "Al Yarmuk",
    "Ghirnatah",
    "Al Hamra",
    "Al Rabwah",
    "Al Janadriyah",
    "Diplomatic Quarter",
  ];

  final List<String> activityTypes = [
    "⚽ Football",
    "🏀 Basketball",
    "🚶 Walking",
    "🏃 Running",
    "🏋️ Gym",
    "🏊 Swimming",
    "🎾 Tennis",
    "🏐 Volleyball",
    "🎨 Drawing",
    "🏺 Pottery",
    "📷 Photography",
    "Other",
  ];

  final List<String> recurringOptions = [
    "Daily",
    "Weekly",
    "Every 2 weeks",
    "Monthly",
  ];

  final Map<String, LatLng> neighborhoodCoordinates = {
    "Al Olaya": const LatLng(24.7136, 46.6753),
    "Al Malaz": const LatLng(24.6877, 46.7228),
    "Al Nakheel": const LatLng(24.7708, 46.6509),
    "Al Muruj": const LatLng(24.7610, 46.6708),
    "Al Yasmin": const LatLng(24.8333, 46.6430),
    "Al Rawdah": const LatLng(24.7452, 46.7700),
    "Al Wurud": const LatLng(24.7355, 46.6644),
    "Al Sahafah": const LatLng(24.7994, 46.6350),
    "Al Narjis": const LatLng(24.8582, 46.6437),
    "Al Aqiq": const LatLng(24.7644, 46.6281),
    "King Abdullah District": const LatLng(24.7448, 46.7095),
    "Al Nadwa": const LatLng(24.794550, 46.876100),
    "Al Nadhim": const LatLng(24.8040, 46.8615),
    "Al Rimal": const LatLng(24.864122, 46.806310),
    "Ishbiliyah": const LatLng(24.8002, 46.7702),
    "Hittin": const LatLng(24.774265, 46.623154),
    "Qurtubah": const LatLng(24.8158, 46.7297),
    "Al Munsiyah": const LatLng(24.8172, 46.7611),
    "Al Yarmuk": const LatLng(24.7936, 46.7578),
    "Ghirnatah": const LatLng(24.7894, 46.7399),
    "Al Hamra": const LatLng(24.7680, 46.7746),
    "Al Rabwah": const LatLng(24.7134, 46.7442),
    "Al Janadriyah": const LatLng(24.9166, 46.8705),
    "Diplomatic Quarter": const LatLng(24.6807, 46.6275),
  };

  @override
  void initState() {
    super.initState();
    _initLocation();
    _googleMapsLinkController.addListener(_onGoogleMapsLinkChanged);
  }

  @override
  void dispose() {
    _activityNameController.dispose();
    _descriptionController.dispose();
    _googleMapsLinkController.dispose();
    _feesController.dispose();
    _maxParticipantsController.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _userLocation = LatLng(position.latitude, position.longitude);

    if (_selectedLocation == null) {
      _selectedLocation = _userLocation;
    }

    if (mounted) {
      setState(() {});
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      _userLocation = LatLng(position.latitude, position.longitude);
      if (mounted) setState(() {});
    });
  }

  void _onGoogleMapsLinkChanged() {
    final link = _googleMapsLinkController.text.trim();
    final extracted = _extractLatLngFromGoogleMapsUrl(link);

    if (extracted != null) {
      setState(() {
        _selectedLocation = extracted;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: extracted, zoom: 15),
          ),
        );
      }
    }
  }

  LatLng? _extractLatLngFromGoogleMapsUrl(String url) {
    if (url.isEmpty) return null;

    final patterns = [
      RegExp(r'@(-?\d+\.?\d*),(-?\d+\.?\d*)'),
      RegExp(r'q=(-?\d+\.?\d*),(-?\d+\.?\d*)'),
      RegExp(r'll=(-?\d+\.?\d*),(-?\d+\.?\d*)'),
      RegExp(r'(-?\d+\.\d+),(-?\d+\.\d+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);

        if (lat != null && lng != null) {
          return LatLng(lat, lng);
        }
      }
    }

    return null;
  }

  String _getPlainActivityName(String value) {
    return value
        .replaceAll("⚽", "")
        .replaceAll("🏀", "")
        .replaceAll("🚶", "")
        .replaceAll("🏃", "")
        .replaceAll("🏋️", "")
        .replaceAll("🏊", "")
        .replaceAll("🎾", "")
        .replaceAll("🏐", "")
        .replaceAll("🎨", "")
        .replaceAll("🏺", "")
        .replaceAll("📷", "")
        .trim();
  }

  String _buildDayTimeText() {
    if (selectedDate == null || selectedTime == null) return '';

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = weekdays[selectedDate!.weekday - 1];
    final hour = selectedTime!.hourOfPeriod == 0 ? 12 : selectedTime!.hourOfPeriod;
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    final period = selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';

    return '$dayName $hour:$minute $period';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  void _moveMapToNeighborhood(String? neighborhood) {
    if (neighborhood == null) return;

    final latLng = neighborhoodCoordinates[neighborhood];
    if (latLng == null) return;

    setState(() {
      _selectedLocation = latLng;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14),
      ),
    );
  }

  Set<Marker> _buildMapMarkers() {
    final markers = <Marker>{};

    if (_selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected_activity_location'),
          position: _selectedLocation!,
          infoWindow: const InfoWindow(title: 'Selected activity location'),
        ),
      );
    }

    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: _userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    return markers;
  }

  void _submitActivity() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity type')),
      );
      return;
    }

    if (selectedNeighborhood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a neighborhood')),
      );
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (activityMode == 'Recurring Group' && recurringFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select recurring frequency')),
      );
      return;
    }

    final lat = _selectedLocation?.latitude ??
        neighborhoodCoordinates[selectedNeighborhood]?.latitude;
    final lng = _selectedLocation?.longitude ??
        neighborhoodCoordinates[selectedNeighborhood]?.longitude;

    final result = {
      "title": _activityNameController.text.trim(),
      "host": createAs == 'Organizer' ? "Organizer" : "Regular_User",
      "activity": selectedActivityType,
      "activityPlain": _getPlainActivityName(selectedActivityType!),
      "description": _descriptionController.text.trim(),
      "riskLevel": riskLevel,
      "location": selectedNeighborhood,
      "neighborhood": selectedNeighborhood,
      "dayTime": _buildDayTimeText(),
      "time": _mapPreferredTimeFromSelectedTime(),
      "participants": 1,
      "spotsLeft":
          (int.tryParse(_maxParticipantsController.text.trim()) ?? 20) - 1,
      "isJoined": false,
      "lat": lat,
      "lng": lng,
      "googleMapsLink": _googleMapsLinkController.text.trim(),
      "fees": _feesController.text.trim(),
      "maxParticipants": _maxParticipantsController.text.trim(),
      "genderPreference": genderPreference,
      "activityMode": activityMode,
      "recurringFrequency": recurringFrequency,
      "date": selectedDate?.toIso8601String(),
      "selectedHour": selectedTime?.hour,
      "selectedMinute": selectedTime?.minute,
    };

    Navigator.pop(context, result);
  }

  String _mapPreferredTimeFromSelectedTime() {
    if (selectedTime == null) return "Daily";

    final hour = selectedTime!.hour;

    if (hour >= 6 && hour < 12) return "Morning (6 AM - 12 PM)";
    if (hour >= 12 && hour < 17) return "Afternoon (12 PM - 5 PM)";
    if (hour >= 17 && hour < 21) return "Evening (5 PM - 9 PM)";
    return "Night (9 PM - 12 AM)";
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF98A2B3),
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }

  Widget _buildSectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 25),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    String? subtitle,
    IconData? icon,
    String? emoji,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? selectedBorderColor : borderColor,
              width: selected ? 1.6 : 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: selected ? primaryColor : subtitleColor,
                  size: 22,
                ),
              if (emoji != null)
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              if (icon != null || emoji != null) const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? titleColor : subtitleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskOption({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? selectedBorderColor : const Color(0xFFD0D5DD),
            width: selected ? 1.6 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? primaryColor : Colors.black87,
                  width: 1.6,
                ),
              ),
              child: selected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: primaryColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: titleColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: titleColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  color: value.isEmpty ? const Color(0xFF98A2B3) : titleColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Column(
      children: [
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              markers: _buildMapMarkers(),
              onMapCreated: (controller) {
                _mapController = controller;

                if (_selectedLocation != null) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _selectedLocation!, zoom: 14),
                    ),
                  );
                }
              },
              onTap: (latLng) {
                setState(() {
                  _selectedLocation = latLng;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF5A6475),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      "Create Activity",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Basic Information",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              "Activity Name *",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _activityNameController,
                              decoration:
                                  _inputDecoration("e.g., Morning Football Match"),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter activity name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Activity Type *",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedActivityType,
                              dropdownColor: Colors.white,
                              decoration: _inputDecoration("Select activity type"),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              ),
                              items: activityTypes.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedActivityType = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select activity type";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Description (optional)",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: _inputDecoration(
                                "Tell participants what to expect...",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              icon: Icons.warning_amber_rounded,
                              iconColor: sectionIconOrange,
                              title: "Risk Level *",
                            ),
                            const SizedBox(height: 18),
                            _buildRiskOption(
                              title: "Low Risk",
                              subtitle:
                                  "Safe environment, minimal physical risk",
                              selected: riskLevel == "Low Risk",
                              onTap: () {
                                setState(() {
                                  riskLevel = "Low Risk";
                                });
                              },
                            ),
                            _buildRiskOption(
                              title: "Medium Risk",
                              subtitle:
                                  "Some physical activity, moderate risk",
                              selected: riskLevel == "Medium Risk",
                              onTap: () {
                                setState(() {
                                  riskLevel = "Medium Risk";
                                });
                              },
                            ),
                            _buildRiskOption(
                              title: "High Risk",
                              subtitle:
                                  "Intense activity, higher injury risk",
                              selected: riskLevel == "High Risk",
                              onTap: () {
                                setState(() {
                                  riskLevel = "High Risk";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              icon: Icons.location_on_outlined,
                              iconColor: sectionIconGreen,
                              title: "Location *",
                              trailing: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    showMapPicker = !showMapPicker;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  showMapPicker ? "Hide Map" : "Pick on Map",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            if (showMapPicker) _buildMapSection(),
                            const SizedBox(height: 18),
                            const Text(
                              "Neighborhood (Riyadh)",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedNeighborhood,
                              dropdownColor: Colors.white,
                              decoration: _inputDecoration("Select neighborhood"),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              ),
                              items: neighborhoods.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedNeighborhood = value;
                                });
                                _moveMapToNeighborhood(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select neighborhood";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            const Row(
                              children: [
                                Icon(Icons.link, size: 18, color: subtitleColor),
                                SizedBox(width: 6),
                                Text(
                                  "Google Maps Link (optional)",
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _googleMapsLinkController,
                              decoration:
                                  _inputDecoration("https://maps.google.com/..."),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              icon: Icons.calendar_today_outlined,
                              iconColor: sectionIconPurple,
                              title: "Date & Time *",
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _buildDateTimeField(
                                  label: "Date",
                                  value: selectedDate == null
                                      ? ""
                                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                  onTap: _pickDate,
                                ),
                                const SizedBox(width: 12),
                                _buildDateTimeField(
                                  label: "Time",
                                  value: selectedTime == null
                                      ? ""
                                      : selectedTime!.format(context),
                                  onTap: _pickTime,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              icon: Icons.people_outline,
                              iconColor: sectionIconOrange,
                              title: "Settings",
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Create as",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildOptionCard(
                                  title: "Regular User",
                                  icon: Icons.person_outline,
                                  selected: createAs == "Regular User",
                                  onTap: () {
                                    setState(() {
                                      createAs = "Regular User";
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildOptionCard(
                                  title: "Organizer",
                                  icon: Icons.people_outline,
                                  selected: createAs == "Organizer",
                                  onTap: () {
                                    setState(() {
                                      createAs = "Organizer";
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Fees (optional)",
                                        style: TextStyle(
                                          color: titleColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _feesController,
                                        keyboardType: TextInputType.number,
                                        decoration: _inputDecoration("0").copyWith(
                                          suffixText: "SAR",
                                          suffixStyle: const TextStyle(
                                            color: subtitleColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Max participants",
                                        style: TextStyle(
                                          color: titleColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _maxParticipantsController,
                                        keyboardType: TextInputType.number,
                                        decoration: _inputDecoration("20"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Gender Preference (optional)",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildOptionCard(
                                  title: "Mixed",
                                  icon: Icons.groups_2_outlined,
                                  selected: genderPreference == "Mixed",
                                  onTap: () {
                                    setState(() {
                                      genderPreference = "Mixed";
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildOptionCard(
                                  title: "Male",
                                  emoji: "👨",
                                  selected: genderPreference == "Male",
                                  onTap: () {
                                    setState(() {
                                      genderPreference = "Male";
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildOptionCard(
                                  title: "Female",
                                  emoji: "👩",
                                  selected: genderPreference == "Female",
                                  onTap: () {
                                    setState(() {
                                      genderPreference = "Female";
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Activity Type",
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildOptionCard(
                                  title: "One-time Event",
                                  selected: activityMode == "One-time Event",
                                  onTap: () {
                                    setState(() {
                                      activityMode = "One-time Event";
                                      recurringFrequency = null;
                                    });
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildOptionCard(
                                  title: "Recurring Group",
                                  selected: activityMode == "Recurring Group",
                                  onTap: () {
                                    setState(() {
                                      activityMode = "Recurring Group";
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (activityMode == "Recurring Group") ...[
                              const SizedBox(height: 18),
                              const Text(
                                "Frequency",
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: recurringFrequency,
                                dropdownColor: Colors.white,
                                decoration: _inputDecoration("How often?"),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                items: recurringOptions.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    recurringFrequency = value;
                                  });
                                },
                              ),
                            ],
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitActivity,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Create Activity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
