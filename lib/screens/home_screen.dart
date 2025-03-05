import 'package:flutter/material.dart';
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

  final List<Widget> _screens = [
    const Dashboard(),
    SchemeListPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey, // Color for unselected labels
        selectedItemColor: Colors.green, // Color for selected label
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,color: Colors.green,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,color: Colors.green,),
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.green,),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
