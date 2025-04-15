import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/settings_screen.dart';
import 'dashboard.dart';
import 'scheme_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _userName = "Loading...";
  final String _userPhone = "Apke Sewa Mai Hagir Hai 🙏🏻";

  final List<Widget> _screens = [
    const Dashboard(),
    const SchemeListPage(),
    const Profile(),
    const SettingsScreen()
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

  void _onDrawerItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); // Close drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "${t.hello}, $_userName 👋",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              accountName: Text(_userName, style: const TextStyle(fontSize: 19)),
              accountEmail: Text(_userPhone, style: const TextStyle(fontSize: 18)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text(t.dashboard),
              onTap: () => _onDrawerItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: Text(t.schemes),
              onTap: () => _onDrawerItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(t.profile),
              onTap: () => _onDrawerItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(t.settings),
              onTap: () => _onDrawerItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(t.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}
