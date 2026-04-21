import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'add_activity_page.dart';
import 'group_details_page.dart';

const String mapStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "transit",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  }
]
''';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const String googleDirectionsApiKey =
      'AIzaSyAmkNAkEYJSxliS1El_chGCa9xKzX-iz_8';

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStreamSubscription;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 11,
  );

  LatLng? _userLocation;
  LatLng _currentCenter = const LatLng(24.7136, 46.6753);

  String? selectedNeighborhood;
  String? selectedActivity;
  String? selectedTime;

  bool hasSearched = false;
  bool showFilters = false;
  bool showMapView = true;

  bool _isTracking = false;
  bool _isFetchingRoute = false;
  bool _isFollowingUser = true;
  bool _isMapReady = false;

  DateTime? _lastRouteFetchTime;

  List<Map<String, dynamic>> filteredActivities = [];
  Map<String, dynamic>? trackedActivity;

  Set<Polyline> _polylines = {};
  Set<Marker> _extraTrackingMarkers = {};

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
    "Al Arid",
    "Al Qirawan",
    "Al Malqa",
    "Al Taawun",
    "Al Izdihar",
    "Al Wadi",
    "Al Falah",
    "Al Nafal",
    "Al Ghadir",
    "Al Khaleej",
    "Al Qadisiyah",
    "Al Andalus",
    "Al Nahdah",
    "Al Salam",
    "Al Manar",
    "Al Jazirah",
    "Al Naseem",
    "Al Saadah",
    "Dhahrat Laban",
    "Tuwaiq",
    "Al Uraija",
    "Al Suwaidi",
    "Al Zahra",
    "Al Dirah",
    "Al Aziziyah",
    "Al Dar Al Baida",
    "Al Badiah",
    "Al Mansourah",
    "Al Fayha",
    "Al Khalidiyah",
    "Diriyah",
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

  final List<String> preferredTimes = [
    "Morning (6 AM - 12 PM)",
    "Afternoon (12 PM - 5 PM)",
    "Evening (5 PM - 9 PM)",
    "Night (9 PM - 12 AM)",
    "Daily",
    "Weekly",
    "Every 2 weeks",
    "Monthly",
  ];

  final List<Map<String, dynamic>> allActivities = [
    {
      "title": "Weekend Football League",
      "host": "Ahmed_Sports",
      "creatorName": "Ahmed_Sports",
      "activity": "⚽ Football",
      "activityPlain": "Football",
      "time": "Morning (6 AM - 12 PM)",
      "dayTime": "Friday 6:00 AM",
      "date": "Friday",
      "description":
          "Join us for an exciting football match with friendly players.",
      "level": "Intermediate",
      "riskLevel": "Intermediate",
      "location": "Al Malaz Stadium",
      "neighborhood": "Al Malaz",
      "participants": 14,
      "spotsLeft": 4,
      "icon": "⚽",
      "isJoined": false,
      "lat": 24.6877,
      "lng": 46.7228,
      "maxParticipants": 18,
    },
    {
      "title": "Padel Night",
      "host": "Padel_Riyadh",
      "creatorName": "Padel_Riyadh",
      "activity": "🎾 Tennis",
      "activityPlain": "Padel",
      "time": "Evening (5 PM - 9 PM)",
      "dayTime": "Tuesday 8:00 PM",
      "date": "Tuesday",
      "description":
          "Night padel game for players who love competition and fun.",
      "level": "Intermediate",
      "riskLevel": "Intermediate",
      "location": "Al Rimal",
      "neighborhood": "Al Rimal",
      "participants": 4,
      "spotsLeft": 0,
      "icon": "🎾",
      "isJoined": false,
      "lat": 24.864122,
      "lng": 46.806310,
      "maxParticipants": 4,
    },
    {
      "title": "Football Match",
      "host": "Nadwa_Team",
      "creatorName": "Nadwa_Team",
      "activity": "⚽ Football",
      "activityPlain": "Football",
      "time": "Evening (5 PM - 9 PM)",
      "dayTime": "Wednesday 6:00 PM",
      "date": "Wednesday",
      "description":
          "A football match for all players in a fun and active group.",
      "level": "Advanced",
      "riskLevel": "Advanced",
      "location": "Al Nadwa",
      "neighborhood": "Al Nadwa",
      "participants": 22,
      "spotsLeft": 3,
      "icon": "⚽",
      "isJoined": false,
      "lat": 24.794550,
      "lng": 46.876100,
      "maxParticipants": 25,
    },
    {
      "title": "Morning Walk",
      "host": "Walk_Group",
      "creatorName": "Walk_Group",
      "activity": "🚶 Walking",
      "activityPlain": "Walking",
      "time": "Morning (6 AM - 12 PM)",
      "dayTime": "Saturday 7:00 AM",
      "date": "Saturday",
      "description": "Relaxing morning walk to start the day with energy.",
      "level": "Beginner",
      "riskLevel": "Beginner",
      "location": "Ishbiliyah Park",
      "neighborhood": "Ishbiliyah",
      "participants": 9,
      "spotsLeft": 3,
      "icon": "🚶",
      "isJoined": false,
      "lat": 24.8002,
      "lng": 46.7702,
      "maxParticipants": 12,
    },
    {
      "title": "Photography Walk",
      "host": "LensClub",
      "creatorName": "LensClub",
      "activity": "📷 Photography",
      "activityPlain": "Photography",
      "time": "Afternoon (12 PM - 5 PM)",
      "dayTime": "Monday 4:00 PM",
      "date": "Monday",
      "description":
          "Capture amazing moments around the city with other photographers.",
      "level": "Beginner",
      "riskLevel": "Beginner",
      "location": "Al Nadhim",
      "neighborhood": "Al Nadhim",
      "participants": 7,
      "spotsLeft": 8,
      "icon": "📷",
      "isJoined": false,
      "lat": 24.8040,
      "lng": 46.8615,
      "maxParticipants": 15,
    },
    {
      "title": "Sports Boulevard Run",
      "host": "RunCrew",
      "creatorName": "RunCrew",
      "activity": "🏃 Running",
      "activityPlain": "Running",
      "time": "Evening (5 PM - 9 PM)",
      "dayTime": "Thursday 6:30 PM",
      "date": "Thursday",
      "description":
          "Join our running group and enjoy a motivating group workout.",
      "level": "Intermediate",
      "riskLevel": "Intermediate",
      "location": "Hittin Track",
      "neighborhood": "Hittin",
      "participants": 11,
      "spotsLeft": 5,
      "icon": "🏃",
      "isJoined": false,
      "lat": 24.774265,
      "lng": 46.623154,
      "maxParticipants": 16,
    },
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
    "Al Arid": const LatLng(24.8170, 46.6000),
    "Al Qirawan": const LatLng(24.8300, 46.6200),
    "Al Malqa": const LatLng(24.8000, 46.6100),
    "Al Taawun": const LatLng(24.7700, 46.6900),
    "Al Izdihar": const LatLng(24.7800, 46.7200),
    "Al Wadi": const LatLng(24.8000, 46.7000),
    "Al Falah": const LatLng(24.7900, 46.7300),
    "Al Nafal": const LatLng(24.7700, 46.6600),
    "Al Ghadir": const LatLng(24.7600, 46.6500),
    "Al Khaleej": const LatLng(24.7900, 46.8000),
    "Al Qadisiyah": const LatLng(24.8100, 46.8200),
    "Al Andalus": const LatLng(24.7500, 46.7800),
    "Al Nahdah": const LatLng(24.7600, 46.7900),
    "Al Salam": const LatLng(24.7200, 46.7800),
    "Al Manar": const LatLng(24.7300, 46.8000),
    "Al Jazirah": const LatLng(24.7000, 46.7500),
    "Al Naseem": const LatLng(24.7400, 46.8100),
    "Al Saadah": const LatLng(24.8000, 46.8300),
    "Dhahrat Laban": const LatLng(24.6800, 46.5800),
    "Tuwaiq": const LatLng(24.6500, 46.5500),
    "Al Uraija": const LatLng(24.6300, 46.6000),
    "Al Suwaidi": const LatLng(24.6000, 46.6500),
    "Al Zahra": const LatLng(24.6200, 46.6200),
    "Al Dirah": const LatLng(24.6300, 46.7100),
    "Al Aziziyah": const LatLng(24.5700, 46.7200),
    "Al Dar Al Baida": const LatLng(24.5500, 46.7500),
    "Al Badiah": const LatLng(24.6000, 46.6800),
    "Al Mansourah": const LatLng(24.6100, 46.7300),
    "Al Fayha": const LatLng(24.6800, 46.7700),
    "Al Khalidiyah": const LatLng(24.6500, 46.7000),
    "Diriyah": const LatLng(24.7333, 46.5740),
  };

  static const Color primaryColor = Color(0xFF19C58B);
  static const Color pageBg = Color(0xFFF5F7F9);
  static const Color titleColor = Color(0xFF1D2740);
  static const Color shadowColor = Color(0x14000000);
  static const Color routeColor = Color(0xFF6C4DFF);

  @override
  void initState() {
    super.initState();
    filteredActivities = List.from(allActivities);
    _initLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  String _normalizeNeighborhood(String value) {
    return value.replaceAll(', Riyadh', '').trim();
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

    if (mounted) {
      setState(() {});
    }

    if (_mapController != null && _userLocation != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: 15,
          ),
        ),
      );
    }

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen((Position position) async {
      _userLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      if (_isTracking && trackedActivity != null) {
        await _refreshTrackingRoute(followUser: true, updateOnlyIfNeeded: true);
      } else {
        setState(() {});
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
  }

  Future<void> _goToMyLocation() async {
    if (_userLocation == null || _mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _userLocation!,
          zoom: 16,
          tilt: 45,
        ),
      ),
    );
  }

  Future<void> _focusOnTrackedRoute() async {
    if (_userLocation == null ||
        trackedActivity == null ||
        _mapController == null) {
      return;
    }

    final lat = trackedActivity!['lat'];
    final lng = trackedActivity!['lng'];

    if (lat is! double || lng is! double) return;

    final destination = LatLng(lat, lng);

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromPoints([
          _userLocation!,
          destination,
        ]),
        80,
      ),
    );
  }

  Future<void> _openAddActivityPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddActivityPage()),
    );

    if (result == null || result is! Map<String, dynamic>) return;

    final normalizedNeighborhood =
        _normalizeNeighborhood((result['neighborhood'] ?? '').toString());

    double? lat = result['lat'] as double?;
    double? lng = result['lng'] as double?;

    if ((lat == null || lng == null) &&
        neighborhoodCoordinates.containsKey(normalizedNeighborhood)) {
      lat = neighborhoodCoordinates[normalizedNeighborhood]!.latitude;
      lng = neighborhoodCoordinates[normalizedNeighborhood]!.longitude;
    }

    final newActivity = Map<String, dynamic>.from(result);
    newActivity['neighborhood'] = normalizedNeighborhood;
    newActivity['location'] =
        result['location']?.toString() ?? normalizedNeighborhood;
    newActivity['lat'] = lat;
    newActivity['lng'] = lng;
    newActivity['isJoined'] = newActivity['isJoined'] ?? false;
    newActivity['participants'] = newActivity['participants'] ?? 1;
    newActivity['spotsLeft'] = newActivity['spotsLeft'] ?? 0;
    newActivity['creatorName'] =
        newActivity['creatorName'] ?? newActivity['host'] ?? 'Creator';
    newActivity['date'] = newActivity['date'] ?? 'Not specified';
    newActivity['description'] = newActivity['description'] ??
        'Join us for this activity and enjoy your time with the group.';
    newActivity['level'] = newActivity['level'] ?? 'Beginner';
    newActivity['riskLevel'] =
        newActivity['riskLevel'] ?? newActivity['level'] ?? 'Beginner';
    newActivity['maxParticipants'] = newActivity['maxParticipants'] ??
        ((newActivity['participants'] ?? 1) + (newActivity['spotsLeft'] ?? 0));

    setState(() {
      allActivities.insert(0, newActivity);
      filteredActivities = List.from(allActivities);
      hasSearched = false;
    });

    if (lat != null && lng != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15,
          ),
        ),
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity added successfully')),
    );
  }

  void performSearch() {
    final results = allActivities.where((activity) {
      final neighborhoodMatch = selectedNeighborhood == null ||
          _normalizeNeighborhood(selectedNeighborhood!) ==
              _normalizeNeighborhood(activity["neighborhood"].toString());

      final activityMatch =
          selectedActivity == null || selectedActivity == activity["activity"];

      final timeMatch =
          selectedTime == null || selectedTime == activity["time"];

      return neighborhoodMatch && activityMatch && timeMatch;
    }).toList();

    setState(() {
      hasSearched = true;
      filteredActivities = results;
    });
  }

  void _showActivityFromMap(Map<String, dynamic> activity) {
    setState(() {
      selectedNeighborhood =
          _normalizeNeighborhood(activity["neighborhood"].toString());
      selectedActivity = activity["activity"]?.toString();
      selectedTime = activity["time"]?.toString();

      filteredActivities = allActivities.where((a) {
        return a["title"]?.toString() == activity["title"]?.toString();
      }).toList();

      hasSearched = true;
      showMapView = false;
    });
  }

  void toggleJoin(Map<String, dynamic> activity) {
    setState(() {
      if (activity["spotsLeft"] == 0 && activity["isJoined"] != true) {
        return;
      }

      if (activity["isJoined"] == true) {
        activity["isJoined"] = false;
        activity["spotsLeft"] += 1;
        activity["participants"] -= 1;
      } else {
        activity["isJoined"] = true;
        activity["spotsLeft"] -= 1;
        activity["participants"] += 1;
      }
    });
  }

  String _distanceText(double? lat, double? lng) {
    if (_userLocation == null || lat == null || lng == null) {
      return "Calculating...";
    }

    final meters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      lat,
      lng,
    );

    if (meters < 1000) {
      return "${meters.toStringAsFixed(0)} m away";
    }

    return "${(meters / 1000).toStringAsFixed(1)} km away";
  }

  Future<void> _startTracking(Map<String, dynamic> activity) async {
    if (_userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location is not ready yet')),
      );
      return;
    }

    final lat = activity['lat'];
    final lng = activity['lng'];

    if (lat is! double || lng is! double) return;

    setState(() {
      trackedActivity = activity;
      _isTracking = true;
      _isFollowingUser = true;
      showMapView = true;
    });

    await _refreshTrackingRoute(followUser: true);
  }

  void _stopTracking() {
    setState(() {
      trackedActivity = null;
      _isTracking = false;
      _isFetchingRoute = false;
      _isFollowingUser = true;
      _polylines = {};
      _extraTrackingMarkers = {};
    });
  }

  Future<void> _refreshTrackingRoute({
    bool followUser = false,
    bool updateOnlyIfNeeded = false,
  }) async {
    if (_userLocation == null || trackedActivity == null) return;

    final lat = trackedActivity!['lat'];
    final lng = trackedActivity!['lng'];

    if (lat is! double || lng is! double) return;

    final destination = LatLng(lat, lng);

    if (updateOnlyIfNeeded && _lastRouteFetchTime != null) {
      final seconds = DateTime.now().difference(_lastRouteFetchTime!).inSeconds;
      if (seconds < 2) {
        if (!mounted) return;

        setState(() {
          _extraTrackingMarkers = _buildTrackingMarkers(destination);
          _polylines = {
            Polyline(
              polylineId: const PolylineId('direct_line'),
              points: [_userLocation!, destination],
              color: Colors.red,
              width: 8,
              geodesic: true,
              zIndex: 1,
            ),
          };
        });

        if (followUser && _isFollowingUser) {
          await _animateToUserLocation();
        }
        return;
      }
    }

    if (mounted) {
      setState(() {
        _isFetchingRoute = true;
      });
    }

    try {
      final polylinePoints = PolylinePoints();

      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleDirectionsApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            _userLocation!.latitude,
            _userLocation!.longitude,
          ),
          destination: PointLatLng(
            destination.latitude,
            destination.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      debugPrint('Route status: ${result.status}');
      debugPrint('Route error: ${result.errorMessage}');
      debugPrint('Route points count: ${result.points.length}');

      _lastRouteFetchTime = DateTime.now();

      List<LatLng> routePoints = [];

      if (result.points.isNotEmpty) {
        routePoints = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      } else {
        routePoints = [_userLocation!, destination];
      }

      if (!mounted) return;

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route_line'),
            points: routePoints,
            color: Colors.red,
            width: 8,
            geodesic: true,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            zIndex: 2,
          ),
        };

        _extraTrackingMarkers = _buildTrackingMarkers(destination);
        _isFetchingRoute = false;
      });

      if (followUser && _isFollowingUser) {
        await _focusOnTrackedRoute();
      }
    } catch (e) {
      debugPrint('Route exception: $e');

      if (!mounted) return;

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route_line_fallback'),
            points: [_userLocation!, destination],
            color: Colors.red,
            width: 8,
            geodesic: true,
            zIndex: 2,
          ),
        };

        _extraTrackingMarkers = _buildTrackingMarkers(destination);
        _isFetchingRoute = false;
      });
    }
  }

  Future<void> _animateToUserLocation() async {
    if (_mapController == null || _userLocation == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _userLocation!,
          zoom: 16,
          tilt: 45,
        ),
      ),
    );
  }

  Set<Marker> _buildTrackingMarkers(LatLng destination) {
    return {
      Marker(
        markerId: const MarkerId('tracking_user_marker'),
        position: _userLocation!,
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      ),
      Marker(
        markerId: const MarkerId('tracking_destination_marker'),
        position: destination,
        infoWindow: InfoWindow(
          title: trackedActivity!['title']?.toString() ?? 'Destination',
          snippet: trackedActivity!['location']?.toString() ?? '',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose,
        ),
      ),
    };
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    if (minLat == maxLat) {
      minLat -= 0.01;
      maxLat += 0.01;
    }

    if (minLng == maxLng) {
      minLng -= 0.01;
      maxLng += 0.01;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (int i = 0; i < allActivities.length; i++) {
      final activity = allActivities[i];
      final lat = activity['lat'];
      final lng = activity['lng'];

      if (lat is double && lng is double) {
        markers.add(
          Marker(
            markerId: MarkerId('activity_marker_$i'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: activity['title']?.toString() ?? 'Activity',
              snippet: activity['location']?.toString() ?? '',
            ),
            onTap: () {
              _showActivityFromMap(activity);
            },
          ),
        );
      }
    }

    if (_userLocation != null && !_isTracking) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_marker_normal'),
          position: _userLocation!,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    markers.addAll(_extraTrackingMarkers);
    return markers;
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 1.4),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              showMapView = true;
            });
          },
          child: Container(
            width: 64,
            height: 48,
            decoration: BoxDecoration(
              color: showMapView ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showMapView ? primaryColor : const Color(0xFFD9D9D9),
              ),
              boxShadow: const [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: showMapView ? Colors.white : Colors.black87,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              showMapView = false;
            });
          },
          child: Container(
            width: 92,
            height: 48,
            decoration: BoxDecoration(
              color: !showMapView ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !showMapView ? primaryColor : const Color(0xFFD9D9D9),
              ),
              boxShadow: const [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "List",
                style: TextStyle(
                  color: !showMapView ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersCard() {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Filters",
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedNeighborhood = null;
                    selectedActivity = null;
                    selectedTime = null;
                    hasSearched = false;
                    filteredActivities = List.from(allActivities);
                    trackedActivity = null;
                    _isTracking = false;
                    _polylines = {};
                    _extraTrackingMarkers = {};
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6E6E6)),
                  ),
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      color: primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      showFilters ? "Hide" : "Show",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedNeighborhood,
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            ),
            decoration: _inputDecoration("Select neighborhood"),
            items: neighborhoods.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedNeighborhood = value;
              });
            },
          ),
          if (showFilters) ...[
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedActivity,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
              decoration: _inputDecoration("Activity type"),
              items: activityTypes.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedTime,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
              decoration: _inputDecoration("Time of day"),
              items: preferredTimes.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: performSearch,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                "Search Activities",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingBanner() {
    if (!_isTracking || trackedActivity == null) {
      return const SizedBox.shrink();
    }

    final lat = trackedActivity!['lat'] as double?;
    final lng = trackedActivity!['lng'] as double?;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.navigation_rounded, color: primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isFetchingRoute
                      ? "Updating live route..."
                      : "Tracking ${trackedActivity!['title']} • ${_distanceText(lat, lng)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: _stopTracking,
                child: const Text(
                  "Stop",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isFollowingUser = !_isFollowingUser;
                    });

                    if (_isFollowingUser) {
                      await _animateToUserLocation();
                    }
                  },
                  icon: Icon(
                    _isFollowingUser
                        ? Icons.gps_fixed_rounded
                        : Icons.gps_not_fixed_rounded,
                    size: 18,
                  ),
                  label: Text(_isFollowingUser ? "Follow ON" : "Follow OFF"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: routeColor,
                    side: const BorderSide(color: routeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _focusOnTrackedRoute,
                  icon: const Icon(Icons.alt_route_rounded, size: 18),
                  label: const Text("Show Route"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 430,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: Set<Marker>.of(_buildMarkers()),
              polylines: Set<Polyline>.of(_polylines),
              onMapCreated: (controller) async {
                _mapController = controller;
                _isMapReady = true;
                await _mapController!.setMapStyle(mapStyle);

                if (_userLocation != null) {
                  await _goToMyLocation();
                }
              },
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              trafficEnabled: false,
              buildingsEnabled: false,
              compassEnabled: true,
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _goToMyLocation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.navigation_outlined,
                            color: Color(0xFF384054)),
                        SizedBox(width: 8),
                        Text(
                          "My Location",
                          style: TextStyle(
                            color: Color(0xFF384054),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isTracking) ...[
                const SizedBox(height: 10),
                Material(
                  color: Colors.white,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _focusOnTrackedRoute,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.alt_route_rounded,
                              color: Color(0xFF384054)),
                          SizedBox(width: 8),
                          Text(
                            "Route",
                            style: TextStyle(
                              color: Color(0xFF384054),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> activity) {
   final bool isCompleted = activity["spotsLeft"] == 0;

    final double? lat =
        activity["lat"] is double ? activity["lat"] as double : null;
    final double? lng =
        activity["lng"] is double ? activity["lng"] as double : null;

    final bool isTrackingThis = trackedActivity != null &&
        trackedActivity!["title"]?.toString() == activity["title"]?.toString();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
     onTap: () {
  final Map<String, dynamic> groupData = {
    ...activity,
    "groupName": activity["title"] ?? "Group",
    "activityName": activity["title"] ?? "Group",
    "activityType": activity["activityPlain"] ?? "Activity",
    "time": activity["dayTime"] ?? activity["time"] ?? "-",
    "isJoined": activity["isJoined"] == true,
    "isCompleted": activity["spotsLeft"] == 0,
    "status": activity["spotsLeft"] == 0 ? "Completed" : "Open",
    "membersCount": activity["participants"] ?? 0,
  };

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => GroupDetailsPage(group: groupData),
    ),
  );
},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isTrackingThis ? routeColor : const Color(0xFFE8E8E8),
            width: isTrackingThis ? 1.4 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity["title"] ?? "",
                style: const TextStyle(
                  color: titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "By ${activity["host"]}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "📍 ${activity["location"]}",
                style: const TextStyle(color: Color(0xFF384054)),
              ),
              const SizedBox(height: 4),
              Text(
                "🕒 ${activity["dayTime"]}",
                style: const TextStyle(color: Color(0xFF384054)),
              ),
              const SizedBox(height: 4),
              Text(
                "👥 ${activity["participants"]} participants",
                style: const TextStyle(color: Color(0xFF384054)),
              ),
              const SizedBox(height: 4),
              Text(
                "📏 ${_distanceText(lat, lng)}",
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          isCompleted ? null : () => toggleJoin(activity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activity["isJoined"] == true
                            ? const Color(0xFFE7FAF3)
                            : isCompleted
                                ? Colors.grey.shade300
                                : primaryColor,
                        foregroundColor: activity["isJoined"] == true
                            ? primaryColor
                            : isCompleted
                                ? Colors.grey.shade700
                                : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        activity["isJoined"] == true
                            ? "Joined"
                            : isCompleted
                                ? "Completed"
                                : "Join (${activity["spotsLeft"]} left)",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: (lat != null && lng != null)
                          ? () async {
                              if (isTrackingThis) {
                                _stopTracking();
                              } else {
                                await _startTracking(activity);
                              }
                            }
                          : null,
                      icon: Icon(
                        isTrackingThis
                            ? Icons.close_rounded
                            : Icons.navigation_rounded,
                        size: 18,
                      ),
                      label: Text(isTrackingThis ? "Stop" : "Track"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: routeColor,
                        side: const BorderSide(color: routeColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (!hasSearched) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filteredActivities.isEmpty
              ? "No results found"
              : "${filteredActivities.length} Results Found",
          style: const TextStyle(
            color: titleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        if (filteredActivities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              "Try changing the filters to see more activities.",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...filteredActivities.map(_buildResultCard),
      ],
    );
  }

  Widget _buildListSectionWithoutSearch() {
    if (showMapView) return const SizedBox.shrink();

    return Column(
      children: filteredActivities.map(_buildResultCard).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        backgroundColor: primaryColor,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
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
                      "Explore Activities",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _openAddActivityPage,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopButtons(),
                    const SizedBox(height: 16),
                    if (showMapView) ...[
                      _buildTrackingBanner(),
                      _buildMapSection(),
                      const SizedBox(height: 18),
                    ],
                    _buildFiltersCard(),
                    const SizedBox(height: 18),
                    if (!showMapView && !hasSearched)
                      _buildListSectionWithoutSearch(),
                    _buildResultsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
