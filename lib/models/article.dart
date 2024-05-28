import 'package:intl/intl.dart';

enum Category { art, food, language, tribe }

Category getCategoryFromString(String str) {
  switch (str) {
    case 'art':
      return Category.art;
    case 'food':
      return Category.food;
    case 'language':
      return Category.language;
    case 'tribe':
      return Category.tribe;
    default:
      throw Exception("Invalid category string: $str");
  }
}

class Article {
  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.imageUrl,
    required this.likedBy,
    required this.author,
    required this.authorId,
    required this.status

  });
  final Category category;
  final DateTime date;
  final String id, title, description, imageUrl, author, status, authorId;
  final List likedBy;

  String get formattedDate {
    return DateFormat.yMMMMd().format(date);
  }
}
