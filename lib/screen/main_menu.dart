import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/article/add_article_screen.dart';
import 'package:javalearn/screen/event/events_screen.dart';
import 'package:javalearn/screen/home/home_screen.dart';
import 'package:javalearn/screen/my-article/my_article_screen.dart';
import 'package:javalearn/screen/profile/profile_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var _currentIndex = 0;

  List<Widget> screen = [
    const HomeScreen(
      isAdmin: false,
    ),
    const MyArticlesScreen(),
    const EventsScreen(),
    const ProfileScreen(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 104, 16, 136),
        foregroundColor: const Color.fromARGB(255, 253, 253, 253),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddArticleScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_rounded),
            label: 'My Article',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
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
