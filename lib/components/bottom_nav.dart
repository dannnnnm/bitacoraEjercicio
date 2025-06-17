import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyBottomNavState createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Inbox', 'Upcoming', 'Completed', 'Settings'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes hacer navegación si usas Navigator, por ejemplo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Pantalla: ${_titles[_selectedIndex]}')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF0F1419),
        unselectedItemColor: Color(0xFF59728C),
        backgroundColor: Color(0xFFF9F9F9),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
