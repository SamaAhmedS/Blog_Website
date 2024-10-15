import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blog/blogs_and_categories/loggedin_page.dart';
import '../service.dart';
import 'blog.dart';

class EditBlog extends StatefulWidget {
  final Blog blog;
  const EditBlog({super.key, required this.blog});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Category? selectedCategory;
  int? timeToRead;
  final BlogService blogServices = BlogService();
  List<Category> categ = cat; // Assuming `cat` is defined elsewhere

  void _submitBlog() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await blogServices.updateBlog(
        blogID: widget.blog.id!, // Make sure this ID is dynamically handled
        blog: Blog(
          title: _titleController.text,
          content: _contentController.text,
          timeToRead: timeToRead!,
          userName: userName, // Ensure userName is defined
          categoryName: selectedCategory!.name,
          categoryID: selectedCategory!.id,
        ),
      );
      if (response) {
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoggedinPage()),
          );
        });
      } else {
        // Handle failure case
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.blog.id);

    if(widget.blog != null){
    _titleController.text = widget.blog.title;
    _contentController.text = widget.blog.content; // Set content text
    selectedCategory = Category(name: widget.blog.categoryName, id: widget.blog.categoryID!);
    timeToRead = widget.blog.timeToRead;
    /*
    _titleController.text = widget.blog.title;
    _contentController.text = widget.blog.content; // Set content text
    selectedCategory = Category(name: widget.blog.categoryName, id: widget.blog.categoryID!);
    timeToRead = widget.blog.timeToRead;
    */

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: selectedCategory,
                    items: categ.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    validator: (value) =>
                    value == null ? 'Please select a category' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Time to Read (minutes)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: timeToRead != null ? timeToRead.toString() : '', // Set initial value
                    onChanged: (value) {
                      setState(() {
                        timeToRead = int.tryParse(value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter time to read';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _submitBlog,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
