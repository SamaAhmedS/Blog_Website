import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'blog.dart';
import 'edit_blog.dart';

class BlogDetailPage extends StatelessWidget {
  final Blog blog;

  BlogDetailPage({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        /*actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => EditBlog(blog: blog,)));
              }
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                blog.img!,
                fit: BoxFit.cover, // Adjust how the image fills the space
                width: 600, // Take up the available width
                height: 300, // Let height adjust dynamically
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Icon(Icons.error); // Show an error icon if image fails to load
                },
              ),
            ),
           /* Image.network(
              blog.img!,
              height: 250,
              fit: BoxFit.cover,
            ),*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Title
                  Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Blog Metadata (User and Date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'By ${blog.userName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(blog.createdAt!),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Blog Category and Reading Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        blog.categoryName,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                          color: Colors.black87, ),
                      ),
                      /*Chip(
                        label: Text(
                          blog.categoryName,
                          style: TextStyle(color: Colors.blue),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),*/
                      Text(
                        '${blog.timeToRead} min read',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Blog Content
                  Text(
                    blog.content,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Comments Section
                  Divider(height: 40, thickness: 1),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 16),
                  blog.comments== null
                      ?
                  ListView.builder(
                    itemCount: blog.comments!.length,
                    itemBuilder: (context, index) {
                      return _buildCommentCard(context, blog.comments![index]);
                    },
                  )/*
                  Column(
                    children: blog.comments.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CommentTile(comment: comment),
                      );
                    }).toList(),
                  )*/
                      : Center(
                    child: Text(
                      'No comments yet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Card _buildCommentCard(BuildContext context, Comment c) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Stack(
            children: [

              Positioned(
                bottom: 16,
                right: 16,
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(c.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white.withOpacity(0.7),
                      ),
                    ),SizedBox(height: 8),
                    Text(
                      c.content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}

