import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen(
      {required this.article,
      required this.triggerLike,
      required this.isAdmin,
      super.key});
  final bool isAdmin;
  final Article article;
  final Function(bool isLiked) triggerLike;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _isLiked = false;
  final _currentUser = FirebaseAuth.instance.currentUser!;
  void _like() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    final userLikes = userData.data()!['liked'];
    if (_isLiked) {
      setState(
        () {
          _isLiked = false;
        },
      );
      widget.article.likedBy.remove(_currentUser.uid);
      userLikes.remove(widget.article.id);
    } else {
      setState(
        () {
          _isLiked = true;
        },
      );
      widget.article.likedBy.add(_currentUser.uid);
      userLikes.add(widget.article.id);
    }
    widget.triggerLike(_isLiked);

    await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .update({'liked_by': widget.article.likedBy});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .update({'liked': userLikes});
  }

  void _updateStatusArticle(String status) async {
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.article.id)
        .update({'status': status});
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    _isLiked = widget.article.likedBy.contains(_currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser!;
    Future.delayed(Duration(seconds: 5), () async {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser.uid)
            .update(
          {
            'history': FieldValue.arrayUnion([widget.article.id])
          },
        );
      } catch (e) {
        print(e);
      }
    });

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            widget.article.title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          actions: [
            widget.isAdmin || widget.article.status != "approved"
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          _like();
                        },
                        icon: _isLiked
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                              )),
                  )
          ],
          toolbarHeight: 65,
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(48),
                ),
                child: Image.network(
                  widget.article.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.article.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  widget.isAdmin && widget.article.status == 'waiting'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _updateStatusArticle('approved');
                              },
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _updateStatusArticle('declined');
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.article.formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 120, 119, 119)),
                  ),
                  Text(
                    'Written by ${widget.article.author}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 120, 119, 119)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
