import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Center(
        child: Text("Homepage"),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: Colors.black, // put the color here
        ),
        child: BottomNavigationBar(
            elevation: 0.0,
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.deepOrange,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.accessibility_sharp),
                  label: "Current Session"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: "Sessions History"),
            ]), // don't forget to put it
      ),
    );
  }
}
