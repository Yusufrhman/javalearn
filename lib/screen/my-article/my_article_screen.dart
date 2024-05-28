import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/widget/article/article_card.dart';

class MyArticlesScreen extends StatefulWidget {
  const MyArticlesScreen({super.key});

  @override
  State<MyArticlesScreen> createState() => _MyArticlesScreenState();
}

class _MyArticlesScreenState extends State<MyArticlesScreen> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  String _searchKey = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   color: const Color.fromARGB(255, 242, 242, 242),
        //   child: TextFormField(
        //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //           fontWeight: FontWeight.normal,
        //           fontSize: 20,
        //         ),
        //     onChanged: (value) {
        //       _searchKey = value;
        //       setState(() {});
        //     },
        //     decoration: InputDecoration(
        //       hintText: 'Search by title..',
        //       suffixIcon: const Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: Icon(
        //           Icons.search,
        //           color: Color.fromARGB(255, 104, 16, 136),
        //         ),
        //       ),
        //       errorStyle: const TextStyle(color: Colors.red),
        //       enabledBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(20.0),
        //         borderSide: const BorderSide(
        //             width: 2, color: Color.fromARGB(255, 104, 16, 136)),
        //       ),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(20.0),
        //         borderSide: const BorderSide(
        //             width: 2, color: Color.fromARGB(255, 104, 16, 136)),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'My Articles',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUser.uid)
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

                  var userArticle =
                      snapshot.data!.data()!['articles'].reversed.toList();
                  if (userArticle.isEmpty) {
                    return Center(
                      child: Text('No Article found, maybe create one?'),
                    );
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userArticle.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('articles')
                              .doc(userArticle[index])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                            var articleData = snapshot.data!.data();
                            Category category =
                                getCategoryFromString(articleData!['category']);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ArticleCard(
                                isAdmin: false,
                                article: Article(
                                  id: userArticle[index],
                                  title: articleData['title'],
                                  description: articleData['description'],
                                  category: category,
                                  date:
                                      DateTime.parse(articleData['date_added']),
                                  imageUrl: articleData['image_url'],
                                  likedBy: articleData['liked_by'],
                                  author: articleData['author'],
                                  status: articleData['status'],
                                  authorId: articleData['userId'],
                                ),
                              ),
                            );
                          });
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
