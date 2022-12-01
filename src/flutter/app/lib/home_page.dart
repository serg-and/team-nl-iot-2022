import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Center(
        child: Text('Homepage'),
      ),
    ); //
  }
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
  bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
      label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(Icons.accessibility_sharp),
      label: "Current Session"),
      BottomNavigationBarItem(
          icon: Icon(Icons.history),
      label: "Sessions History"),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.white,
  backgroundColor: Colors.deepOrange,
  onTap: _onItemTapped,

  ),
  );
}
  }

