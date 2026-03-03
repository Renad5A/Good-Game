import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late GoogleMapController _mapController;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753), // الرياض
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Activities"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🗺️ Google Map
          SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),

          const SizedBox(height: 15),

          // 🔍 Filters Card
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: "Select neighborhood",
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: "Olaya", child: Text("Al Olaya")),
                                DropdownMenuItem(
                                    value: "Malaz", child: Text("Al Malaz")),
                              ],
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1FAF7A),
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                                label: const Text("Search Activities"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📋 Activity List
                  activityCard(
                    title: "Padel Night",
                    location: "Al Olaya, Riyadh",
                    date: "Feb 24, 2026",
                    time: "8:00 PM",
                    spots: "2/4",
                  ),

                  activityCard(
                    title: "Photography Walk",
                    location: "Al Malaz, Riyadh",
                    date: "Feb 25, 2026",
                    time: "4:00 PM",
                    spots: "1/10",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget activityCard({
    required String title,
    required String location,
    required String date,
    required String time,
    required String spots,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18),
                  const SizedBox(width: 5),
                  Text(location),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 5),
                  Text(date),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 5),
                  Text(time),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Low Risk",
                      style: TextStyle(color: Colors.green)),
                  Text("👥 $spots"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
