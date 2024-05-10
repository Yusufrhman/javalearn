import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/widget/article/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedFilterCategory;
  void _filterCategory(Category category) {
    if (category.name == _selectedFilterCategory) {
      _selectedFilterCategory = null;
    } else {
      _selectedFilterCategory = category.name;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _currentUser = FirebaseAuth.instance.currentUser!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  _currentUser.displayName!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 24, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
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
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Category',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _filterCategory(Category.art);
                      },
                      icon: const Icon(Icons.art_track),
                      label: const Text('Art'),
                      style: _selectedFilterCategory == Category.art.name
                          ? ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 104, 16, 136)),
                            )
                          : ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 104, 16, 136),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 104, 16, 136),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _filterCategory(Category.food);
                      },
                      icon: const Icon(Icons.food_bank),
                      label: const Text('Food'),
                      style: _selectedFilterCategory == Category.food.name
                          ? ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 104, 16, 136)),
                            )
                          : ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 104, 16, 136),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 104, 16, 136),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _filterCategory(Category.language);
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('Language'),
                      style: _selectedFilterCategory == Category.language.name
                          ? ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(160, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 104, 16, 136)),
                            )
                          : ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 104, 16, 136),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 104, 16, 136),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(160, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _filterCategory(Category.tribe);
                      },
                      icon: const Icon(Icons.people),
                      label: const Text('Tribe'),
                      style: _selectedFilterCategory == Category.tribe.name
                          ? ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 104, 16, 136)),
                            )
                          : ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 104, 16, 136),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Color.fromARGB(255, 104, 16, 136),
                                  width: 1,
                                ),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(130, 60)),
                              iconSize: MaterialStateProperty.all<double?>(40),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'List Article',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              StreamBuilder(
                stream: widget.isAdmin
                    ? FirebaseFirestore.instance
                        .collection('articles')
                        .where('category', isEqualTo: _selectedFilterCategory)
                        .where('status', isEqualTo: 'waiting')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('articles')
                        .where('category', isEqualTo: _selectedFilterCategory)
                        .where('status', isEqualTo: 'approved')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Expanded(
                      child: Center(
                        child: Text('error'),
                      ),
                    );
                  }

                  var articleData = snapshot.data!.docs.toList();
                  articleData.sort(
                      (a, b) => (a['date_added']).compareTo(b['date_added']));
                  articleData = articleData.reversed.toList();

                  if (articleData.isEmpty) {
                    return const Center(
                      child: Text('No Article found'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: articleData.length,
                    itemBuilder: (context, index) {
                      Category category =
                          getCategoryFromString(articleData[index]['category']);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ArticleCard(
                          isAdmin: widget.isAdmin,
                          article: Article(
                              id: articleData[index].id,
                              title: articleData[index]['title'],
                              description: articleData[index]['description'],
                              category: category,
                              date: DateTime.parse(
                                  articleData[index]['date_added']),
                              imageUrl: articleData[index]['image_url'],
                              likedBy: articleData[index]['liked_by'],
                              author: articleData[index]['author'],
                              status: articleData[index]['status']),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
