import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/screen/article/article_screen.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard({super.key, required this.article, required this.isAdmin});
  final Article article;
  final bool isAdmin;
  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  bool _isLiked = false;
  var _totalLike = 0;
  void _like() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();

    final userLikes = userData.data()!['liked'];
    print('wkwk');
    print(userLikes);
    if (_isLiked) {
      _totalLike--;
      setState(
        () {
          _isLiked = false;
        },
      );
      widget.article.likedBy.remove(_currentUser.uid);
      userLikes.remove(widget.article.id);
    } else {
      _totalLike++;
      setState(
        () {
          _isLiked = true;
        },
      );
      widget.article.likedBy.add(_currentUser.uid);
      userLikes.add(widget.article.id);
    }
    print(userLikes);
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
  }

  @override
  void initState() {
    _totalLike = widget.article.likedBy.length;
    _isLiked = widget.article.likedBy.contains(_currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 252, 252),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleScreen(
                        isAdmin: widget.isAdmin,
                        article: widget.article,
                        triggerLike: (value) {
                          setState(() {
                            _isLiked = value;
                            value ? _totalLike++ : _totalLike--;
                          });
                        },
                      )));
        },
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 120,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: NetworkImage(widget.article.imageUrl),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.375,
                          child: Text(
                            widget.article.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                        ),
                        Text(
                          widget.article.category.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                child: widget.isAdmin
                    ? Column(
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
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _updateStatusArticle('declined');
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : widget.article.status != 'approved'
                        ? widget.article.status == 'declined'
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 251, 177, 177),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Text(
                                  widget.article.status,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 186, 0, 0)),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 171, 255, 237),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Text(
                                  widget.article.status,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 167, 128)),
                                ),
                              )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _like();
                                },
                                child: _isLiked
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                              ),
                              Text(
                                _totalLike.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
