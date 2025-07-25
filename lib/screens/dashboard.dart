import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/nearby_offices_screen.dart';
import 'complaint_screen.dart';
import 'track_status.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> imageAssets = const [
    'assets/images/pkvy.png',
    'assets/images/pm-kisan.png',
    'assets/images/pmfby.png',
    'assets/images/pmkmy.png',
  ];

  final List<Map<String, dynamic>> gridItems = const [
    {'icon': Icons.description, 'label': 'documents', 'route': '/documents'},
    {'icon': Icons.track_changes, 'label': 'trackApplication', 'route': '/track_application'},
    {'icon': Icons.location_on, 'label': 'nearbyServices', 'route': '/nearby_services'},
    {'icon': Icons.report_problem, 'label': 'complaint', 'route': '/complaint'},
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/sch.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.8,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                    ),
                    items: imageAssets.map((assetPath) {
                      return Builder(
                        builder: (BuildContext context) {
                          if (kDebugMode) {
                            print('Loading asset: $assetPath');
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                assetPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        t.imageNotFound,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Opacity(
                    opacity: 0.8,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: gridItems.length,
                      itemBuilder: (context, index) {
                        final labelKey = gridItems[index]['label'];
                        final label = {
                          'documents': t.documents,
                          'trackApplication': t.trackApplication,
                          'nearbyServices': t.nearbyServices,
                          'complaint': t.complaint,
                        }[labelKey] ?? labelKey;

                        return InkWell(
                          onTap: () {
                            if (labelKey == 'trackApplication') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TrackStatusScreen()),
                              );
                            } else if (labelKey == 'nearbyServices') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NearbyOfficesScreen()),
                              );
                            } else if (labelKey == 'complaint') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ComplaintPage()),
                              );
                            } else {
                              Navigator.pushNamed(context, gridItems[index]['route']);
                            }
                          },
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(gridItems[index]['icon'], size: 48.0, color: Colors.blue),
                                const SizedBox(height: 8.0),
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
