import 'dart:io';
import 'package:blog/blogs_and_categories/loggedin_page.dart';
import '../service.dart';
import 'blog.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:async';
class BlogCreation extends StatefulWidget {
  const BlogCreation({super.key});

  @override
  State<BlogCreation> createState() => _BlogCreationState();
}
class _BlogCreationState extends State<BlogCreation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  File? _imageFile;
  Category? selectedCategory;
  int? timeToRead;

  /*final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }*/
  late Future<List<Category>> categories;
  List<Category> categ = cat;
  final BlogService blogServices = BlogService();

  @override
  void initState() {
    super.initState();
    // Fetch the blogs and store them
    categories = blogServices.getAllCategories();
  }


  void _submitBlog()async{
    //blogServices.getAllCategories();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await blogServices.addBlog(
        Blog(title: _titleController.text, content: _contentController.text, timeToRead: timeToRead!, userName: userName, categoryName: selectedCategory!.name, categoryID: selectedCategory!.id)
      );
      blogServices.updateBlog(blogID:9,
        blog: Blog(title: _titleController.text, content: _contentController.text, timeToRead: timeToRead!, userName: userName, categoryName: selectedCategory!.name, categoryID: selectedCategory!.id)
      );
      if (response == true) {
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoggedinPage()));
        });
      } else {
      }
    }

  }
  //final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
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
                    GestureDetector(
                      onTap: () {
                        // _pickImage
                      },
                      child: _imageFile != null
                          ? Image.file(_imageFile!, height: 150)
                          : Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[600],
                          size: 50,
                        ),
                      ),
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
                  width: 300, // Set a specific width
                  child: ElevatedButton(
                    onPressed: _submitBlog,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Submit'),
                  ),
                ),
                    /*ElevatedButton(
                      onPressed: _submitBlog,

                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        textStyle: TextStyle(fontSize: 16),

                      ),
                      child: Text('Submit'),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}