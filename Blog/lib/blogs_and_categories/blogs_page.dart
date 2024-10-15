import 'package:flutter/material.dart';
import 'blog.dart';
import 'edit_blog.dart';
import 'blog_detail_page.dart';
import 'package:blog/service.dart';

class BlogsPage extends StatefulWidget {
  bool isLoggedIn;

  BlogsPage({required this.isLoggedIn});

  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  late Future<List<Blog>> blogs;
  final BlogService blogServices = BlogService();

  @override
  void initState() {
    super.initState();
    // Fetch the blogs and store them
    blogs = fetchAndExtractBlogs();
  }

  // Helper function to fetch blogs and return only the List<Blog>
  Future<List<Blog>> fetchAndExtractBlogs() async {
    var response = await blogServices.fetchBlogs();
    List<Blog> blogsList = response[4] as List<Blog>; // Extracting blogs from response[4]
    return blogsList;
  }

  // Method to refetch blogs and update the UI
  void refreshBlogs() {
    setState(() {
      blogs =fetchAndExtractBlogs(); // Re-fetch the blogs when called
    });
  }
  void showMorePosts(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FutureBuilder<List<Blog>>(
        future: blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display loading screen while data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Display error message if fetching fails
            return Center(
              child: Text('Failed to load blogs'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Display message if no blogs are available
            return Center(
              child: Text('No blogs available'),
            );
          } else {
            // Blogs have been successfully fetched, display them in a list
            List<Blog> blogsList = snapshot.data!;
            return ListView.builder(
              itemCount: blogsList.length,
              itemBuilder: (context, index) {
                return _buildBlogCard(context, blogsList[index]);
              },
            );
          }
        },
      ),
    );
  }

  // Blog card UI
  Widget _buildBlogCard(BuildContext context, Blog blog) {
    print('');

    print(blog.id);
    print('');
    return GestureDetector(
      onTap: () {
        // Navigate to Blog Details Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailPage(blog: blog),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Stack(
          children: [
            // Blog Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                blog.img!,
                width: 500,
                height: 400,
                fit: BoxFit.cover,
              ),
                  /*blog.img.isNotEmpty
                  ? Image.network(
                blog.img,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),*/
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.categoryName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      backgroundColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    blog.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    blog.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      backgroundColor: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Delete Icon for Logged-in Users
            widget.isLoggedIn
                ? Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.indigo,
                ),
                onPressed: () {
                  // Show confirmation dialog before deleting
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete this blog?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              blogServices.deleteBlog(blog.id!); // Delete blog
                              refreshBlogs(); // Refresh blogs after deletion
                              Navigator.of(context).pop(); // Close dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
                : Container(),
            widget.isLoggedIn
                ? Positioned(
              top: 16,
              right: 55,
              child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ),
                  onPressed: (){
                    print(blog.id);
                    if(blog != null){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => EditBlog(blog: blog)));
                    }
                  }
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
