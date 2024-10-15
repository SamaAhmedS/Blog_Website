import 'package:blog/app_consts.dart';

class Category{
  String name;
  int id;
  String? description;
  Category({required this.name,this.description, required this.id});
  factory Category.fromJson(Map<String, dynamic> json) {
    var commentList = json['comments'] as List;
    List<Comment> comments = commentList.map((c) => Comment.fromJson(c)).toList();

    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
class Blog {
  final int? id;
  final String title;
  final String content;
  final String? img;
  final DateTime? createdAt;
  final int timeToRead;
  final String userName;
  final String categoryName;
  final int? categoryID;
  final List<Comment>? comments;

  Blog({
    this.id,
    required this.title,
    required this.content,
    this.img,
    this.createdAt,
    required this.timeToRead,
    required this.userName,
    required this.categoryName,
    this.categoryID,
    this.comments,
  });// Factory method to create a Blog object from JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    var commentList = json['comments'] as List;
    List<Comment> comments = commentList.map((c) => Comment.fromJson(c)).toList();

    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      //img: json['img'] ?? '${assetsImagesPath}img.png', // Handle possible null
      img: '${assetsImagesPath}img.png', // Handle possible null
      createdAt: DateTime.parse(json['createdAt']),
      timeToRead: json['timeToRead'],
      userName: json['userName'],
      categoryName: json['category'],
      comments: comments,
    );
  }
}

class Comment {
  final String username;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.username,
    required this.content,
    required this.createdAt,
  });

  // Factory method to create a Comment object from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
final List<Category> cat = [
  Category(name: 'Art', description: '', id: 1),
  Category(name: 'Engineering', description: '', id: 2),
  Category(name: 'Software', description: '', id: 3),

];
/*
final List<Blog> blogs = [
  Blog(
      id: 7, title: 'Second Post So Far',
      content: 'This is the second post so far on Bloggy! ....',
      img: '',
      //createdAt: DateTime.parse(2024-09-06T13:58:40.2034657),
      timeToRead: 5,
      userName: 'UserOne',
      categoryName: 'Engineering',
      comments: [Comment(username: 'UserOne', content: 'Hey, You!',
        //createdAt: 2024-09-06T14:29:00.4539555
      )]
  ),

];*/
