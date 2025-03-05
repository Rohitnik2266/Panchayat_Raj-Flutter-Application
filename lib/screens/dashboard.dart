import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final List<String> imageUrls = [
      'https://via.placeholder.com/400x200.png?text=Gram+Panchayat+1',
      'https://via.placeholder.com/400x200.png?text=Gram+Panchayat+2',
      'https://via.placeholder.com/400x200.png?text=Gram+Panchayat+3',
      'https://via.placeholder.com/400x200.png?text=Gram+Panchayat+4',
    ];

    return Scaffold(
      body: SafeArea(
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
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Namaste 🙏🏻',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/submit_application');
                              },
                              icon: const Icon(Icons.article, color: Colors.green),
                              label: const Text('Submit Application', style: TextStyle(color: Colors.green)),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/track_status');
                              },
                              icon: const Icon(Icons.track_changes, color: Colors.green),
                              label: const Text('Track Status', style: TextStyle(color: Colors.green)),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/notifications');
                              },
                              icon: const Icon(Icons.notifications, color: Colors.green),
                              label: const Text('Notifications', style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                      ],
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
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FlutterLogo(size: 48.0),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Item ${index + 1}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
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
      ),
    );
  }
}