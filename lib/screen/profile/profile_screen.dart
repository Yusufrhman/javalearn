import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/auth/login_checker.dart';
import 'package:javalearn/screen/profile/edit_profile_screen.dart';
import 'package:javalearn/screen/profile/history_article.dart';
import 'package:javalearn/screen/profile/liked_article.dart';

final _firebaseAuth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isAdmin = false});
  final bool isAdmin;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _currentUser = _firebaseAuth.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.75,
                    color: const Color.fromARGB(255, 104, 16, 136),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(100))),
              child: ClipOval(
                child: _currentUser.photoURL != null
                    ? Image.network(
                        _currentUser.photoURL!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/profile.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      _currentUser.displayName!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 20,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      _currentUser.email!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        widget.isAdmin
            ? const SizedBox(
                height: 0,
              )
            : Ink(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 104, 16, 136),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            "Edit Profile",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
        widget.isAdmin
            ? const SizedBox(
                height: 0,
              )
            : const SizedBox(
                height: 20,
              ),
        widget.isAdmin
            ? const SizedBox(
                height: 0,
              )
            : Ink(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 104, 16, 136),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 40,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            "Liked",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LikedArticleScreen()));
                  },
                ),
              ),
        widget.isAdmin
            ? const SizedBox(
                height: 0,
              )
            : const SizedBox(
                height: 20,
              ),
        widget.isAdmin
            ? const SizedBox(
                height: 0,
              )
            : Ink(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 104, 16, 136),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: const Icon(
                              Icons.history,
                              size: 40,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            "History",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HistoryArticleScreen()));
                  },
                ),
              ),
        const SizedBox(
          height: 60,
        ),
        Ink(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: const Icon(
                        Icons.logout,
                        size: 40,
                        color: Color.fromARGB(255, 104, 16, 136),
                      ),
                    ),
                    Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) {
                return;
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginChecker()));
            },
          ),
        ),
      ],
    );
  }
}
