import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:panchayat_raj/screens/profile_screen.dart';
import 'package:panchayat_raj/screens/scheme_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String _userName = "Loading...";

  final List<Widget> _screens = [
    const HomeScreen(),
    const SchemeListPage(),
    const Profile(),
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}

// ✅ Home Screen with Carousel & Grid Menu
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> imageUrls = const [
    'https://img.jagrantv.com/gram_pachayattt.jpg',
    'https://boldnewsonline.com/wp-content/uploads/2021/09/graham-sabha-750x322.jpg',
    'https://dainiknews24.in/wp-content/uploads/2024/03/agrowon_2022-11_fb823891-54c0-49fa-8b14-7af015cd9c62_11Grampanchyat_1_0.jpg',
    'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiqdWk_biEROu9iwg_L_2JrD5Bkkze7daKU5unMKCtBvVbV4EUkTQBSabSeVNnSGg0VqtSKwl3tuV8BLOTr8C-0RxdCJkyJBdlc7hs_L2_0omf-aCLP9XbNF_ET8gxTIJxvx1_sCQGVurZZpl5NWc303qjLFlC1Xlz3QDEpoKC01q7RMgBq5wpeRBTVhgw/s1199/13june.jpg',
  ];

  final List<Map<String, dynamic>> gridItems = const [
    {'icon': Icons.description, 'label': 'Documents', 'route': '/documents'},
    {'icon': Icons.calendar_today, 'label': 'Appointments', 'route': '/appointments'},
    {'icon': Icons.location_on, 'label': 'Nearby Services', 'route': '/nearby_services'},
    {'icon': Icons.people, 'label': 'Community', 'route': '/community'},
  ];

  @override
  Widget build(BuildContext context) {
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
                // ✅ Carousel
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
                    items: imageUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover,
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

                // ✅ Grid Menu
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
                        return InkWell(
                          onTap: () => Navigator.pushNamed(context, gridItems[index]['route']),
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
                                  gridItems[index]['label'],
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
