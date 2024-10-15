/*
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
        body: ListView(

          padding: const EdgeInsets.all(16.0),
          children: [ Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),SizedBox(height: 8),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
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
                    onTap: (){},//_pickImage,
                    child: _imageFile != null
                        ? Image.file(_imageFile!, height: 150)
                        : Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    decoration: InputDecoration(labelText: 'Select Category'),
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
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Time to Read (minutes)'),
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
                  ElevatedButton(
                    onPressed: _submitBlog,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
            ],
        ),
      );
  }
}

* */