import 'package:flutter/material.dart';
import 'package:panchayat_raj/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'Schemes List',
      theme: ThemeData(
        primarySwatch: Colors.green, // Sets a green theme
      ),
      home: WillPopScope(
        onWillPop: () async => false, // Disable back button functionality
        child: const SchemeListPage(),
      ),
    );
  }
}

class SchemeListPage extends StatelessWidget {
  const SchemeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Scheme> schemes = [
      Scheme(
        name: "Gramin Rozgar Yojana",
        description: "A scheme for rural employment.",
      ),
      Scheme(
        name: "Mahatma Gandhi National Rural Employment Guarantee Act",
        description: "Provides wage employment to rural families.",
      ),
      Scheme(
        name: "Pradhan Mantri Gram Sadak Yojana",
        description: "Improves rural road infrastructure.",
      ),
      Scheme(
        name: "Swachh Bharat Abhiyan",
        description: "Aimed at improving sanitation in rural and urban India.",
      ),
      Scheme(
        name: "Pradhan Mantri Awas Yojana",
        description: "Affordable housing scheme for rural and urban poor.",
      ),
      Scheme(
        name: "Atal Pension Yojana",
        description: "A social security scheme for unorganized sector workers.",
      ),
      Scheme(
        name: "Jan Dhan Yojana",
        description: "Promotes financial inclusion by opening bank accounts.",
      ),
      Scheme(
        name: "Digital India",
        description:
        "Focuses on transforming India into a digitally empowered society.",
      ),
      Scheme(
        name: "Skill India Mission",
        description:
        "Aims to train youth in various skills to enhance employability.",
      ),
      Scheme(
        name: "Beti Bachao Beti Padhao",
        description: "Promotes the welfare of girls and their education.",
      ),
      Scheme(
        name: "Ujjwala Yojana",
        description:
        "Provides LPG connections to women from Below Poverty Line families.",
      ),
      Scheme(
        name: "PM-Kisan Samman Nidhi",
        description:
        "Provides financial assistance to farmers for their needs.",
      ),
    ];

    // Divide the schemes into two lists
    List<Scheme> activeSchemes = schemes.sublist(0, 6);  // First 6 schemes for active
    List<Scheme> pastSchemes = schemes.sublist(6);       // Remaining schemes for past

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schemes List'),
      ),
      body: ListView(
        children: [
          // Active Schemes Section
          const SizedBox(height: 20),
          const SectionTitle(title: 'Active Schemes'),
          ...activeSchemes.map((scheme) => SchemeCard(scheme: scheme)).toList(),

          const SizedBox(height: 20),
          const Divider(),

          // Past Schemes Section
          const SectionTitle(title: 'Past Schemes'),
          ...pastSchemes.map((scheme) => SchemeCard(scheme: scheme)).toList(),
        ],
      ),
    );
  }
}

class SchemeCard extends StatelessWidget {
  final Scheme scheme;

  const SchemeCard({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scheme.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 91, 3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              scheme.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Scheme {
  final String name;
  final String description;

  Scheme({required this.name, required this.description});
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( // Use Consumer to access ThemeProvider
      builder: (context, themeProvider, _) {
        final theme = Theme.of(context); // Access current theme
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: theme.textTheme.titleLarge!.copyWith(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    );
  }
}