import 'package:flutter/material.dart';
import 'blogs_page.dart';
import 'create_blog.dart';
import 'package:blog/service.dart';

class LoggedinPage extends StatefulWidget {
  const LoggedinPage({super.key});

  @override
  State<LoggedinPage> createState() => _LoggedinPageState();
}

class _LoggedinPageState extends State<LoggedinPage> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {

    late List<Widget> _pages= [
      BlogsPage(isLoggedIn: true),
      BlogCreation(),

    ];
    List<String> titels = ['My blogs', 'Create a blog'];
    return Scaffold(
      body: _pages[selectedPage],

      appBar: AppBar(
        title: Text(titels[selectedPage]),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedPage = 1;
              });
              /*Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>));*/

            },
            child: Text(
              'Create blog',
              style: TextStyle(color: Colors.white), // White text color
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedPage = 0;
              });
            },
            child: Text(
              'My Blogs',
              style: TextStyle(color: Colors.white), // White text color
            ),
          ),
        ],
        backgroundColor: Colors.blue, // You can change the AppBar color
      ),
    );
  }
}
