import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
import 'beranda_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
<<<<<<< HEAD
  final int initialIndex; // TAMBAHKAN INI
  
  const MainNavigationScreen({Key? key, this.initialIndex = 0}) : super(key: key);
=======
  const MainNavigationScreen({Key? key}) : super(key: key);
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
<<<<<<< HEAD
  late int _currentIndex; // UBAH JADI LATE

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // SET INDEX AWAL
  }
=======
  int _currentIndex = 0;
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8

  final List<Widget> _pages = [
    const HomeScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B3D2E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
