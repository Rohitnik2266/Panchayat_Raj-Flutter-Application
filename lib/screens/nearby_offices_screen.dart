import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class NearbyOfficesScreen extends StatefulWidget {
  const NearbyOfficesScreen({super.key});

  @override
  State<NearbyOfficesScreen> createState() => _NearbyOfficesScreenState();
}

class _NearbyOfficesScreenState extends State<NearbyOfficesScreen> {
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  final List<LatLng> _officeLocations = [];

  static const String _apiKey = 'AIzaSyCo1FrHmYMc5xyzHuKHpO5KHdriIa3DSPs'; // Replace this

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    print("Requesting location permission...");
    final permission = await Permission.location.request();

    if (permission.isGranted) {
      print("Location permission granted.");
      print("Fetching position...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      print("User location: $_currentLocation");
      await _getNearbyPanchayatOffices(position.latitude, position.longitude);
    } else {
      print("Permission denied: $permission");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }


  Future<void> _getNearbyPanchayatOffices(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng&radius=3000'
          '&type=local_government_office'
          '&keyword=panchayat'
          '&key=$_apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        debugPrint('Found ${results.length} Panchayat offices nearby.');

        setState(() {
          _officeLocations.clear();
          for (var place in results) {
            final location = place['geometry']['location'];
            _officeLocations.add(
              LatLng(location['lat'], location['lng']),
            );
          }
        });
      } else {
        debugPrint('Failed to fetch nearby offices: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Panchayat offices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Panchayat Offices'),
        backgroundColor: Colors.green,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : _officeLocations.isEmpty
          ? const Center(child: Text('No Panchayat offices found nearby.'))
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 15,
        ),
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
          ..._officeLocations.map(
                (loc) => Marker(
              markerId: MarkerId(loc.toString()),
              position: loc,
              infoWindow: const InfoWindow(
                title: 'Panchayat Service Office',
              ),
            ),
          ),
        },
      ),
    );
  }
}
