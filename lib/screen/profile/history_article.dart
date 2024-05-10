import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/widget/article/article_card.dart';

class HistoryArticleScreen extends StatefulWidget {
  const HistoryArticleScreen({super.key});

  @override
  State<HistoryArticleScreen> createState() => _HistoryArticleScreenState();
}

class _HistoryArticleScreenState extends State<HistoryArticleScreen> {
  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
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
                  snapshot.data!.data()!['history'].reversed.toList();
              if (userArticle.isEmpty) {
                return const Center(
                  child: Text('No History found, maybe View one?'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                physics: const NeverScrollableScrollPhysics(),
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
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ArticleCard(
                            isAdmin: false,
                            article: Article(
                                author: articleData['author'],
                                id: userArticle[index],
                                title: articleData['title'],
                                description: articleData['description'],
                                category: category,
                                date: DateTime.parse(articleData['date_added']),
                                imageUrl: articleData['image_url'],
                                likedBy: articleData['liked_by'],
                                status: articleData['status']),
                          ),
                        );
                      });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
