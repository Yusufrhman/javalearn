import 'package:flutter/material.dart';
import 'package:javalearn/screen/article/add_article_screen.dart';
import 'package:javalearn/screen/home/home_screen.dart';
import 'package:javalearn/screen/profile/profile_screen.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  var _currentIndex = 0;

  List<Widget> screen = [
    const HomeScreen(
      isAdmin: true,
    ),
    const ProfileScreen(
      isAdmin: true,
    ),
  ];
  changeScreen(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 60),
        child: screen[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 104, 16, 136),
        onTap: changeScreen,
      ),
    );
  }
}
