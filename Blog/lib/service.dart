import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import'blogs_and_categories/blog.dart';
String token = '';
String userName = 'UserOne';

class AuthService {
  final String baseUrl = 'http://bloggy.runasp.net/api/Auth';

  Future<http.Response> registerUser({required String name, required String email, required String password, required String confirmedPassword}) async {

    final url = Uri.parse('$baseUrl/Register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Name' : name,
        'Email': email,
        'Password': password,
        'ConfirmPassword': confirmedPassword,
      }),
    );
    print('reg reg here');
    var responseData = jsonDecode(response.body);
    print('User registered ${responseData}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        // Instead of decoding, handle it as a string (assuming it's a token)
        var responseData = jsonDecode(response.body);
        print('User registered ${responseData}');

      } else {
        print('Response body is empty');
      }
    } else {
      print('Reg Failed with status code: ${response.statusCode}');
    }
    return response;
  }
  /*Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }*/

  Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/Login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        token = response.body;

        /*final BlogService service = BlogService();
        service.fetchBlogs();
        */
        print('Token: ${response.body}');
        print('');
        print('');
      } else {
        print('Response body is empty');
      }
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
    return response;
  }

  Future<void> logoutUser() async {
    final url = Uri.parse('$baseUrl/Logout');
    await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

}
class UserServices{
  final String baseUrl = 'http://bloggy.runasp.net/api/User';


  Future<void> getAllUsers() async {
    final url = Uri.parse('$baseUrl/getAll');///{User1@gmail.com}
    try {
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the status code indicates a successful response
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          // Parse JSON data
          var responseData = jsonDecode(response.body);
          // Assuming the responseData is a list of users or contains a 'name' field
          print('Status code: ${response.statusCode}');
          print('User name: ${responseData['name']}'); // Adjust this as per your actual response
        } else {
          print('Response body is empty');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
class BlogService{
  final String baseUrl = 'http://bloggy.runasp.net/api';
  Future<bool> addBlog(Blog blog)async{

    final url = Uri.parse('$baseUrl/post/add');
    print('here in add \n title:${blog.title}, \n content: ${blog.content} \n categoryId: ${blog.categoryID}\n timeToRead: ${blog.timeToRead}');
    final response;
    try{
      response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Ensure the Content-Type is correct
          'Authorization': 'Bearer $token',  // Include the authorization token
        },

        body: jsonEncode({
        //'postDto': {
          'title': blog.title,
          'content': blog.content,
          //'img': null,
          //'comments':[],
          'timeToRead': blog.timeToRead,
          'categoryId': blog.categoryID,
        //}
        }),
      );
      if (response.statusCode == 200) {
        print('Blog added successfully');
        return true;
      } else {
        print('Failed to add blog. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
  } catch (e) {
  print('blog Error: $e');
  }
    return false;
  }
  Future<int> getCategoryByName(String name) async {
    List<Category> categories = await getAllCategories(); // await here

    try {
      // Find the category where the name matches the provided name
      Category category = categories.firstWhere((category) => category.name == name);

      // Return the id of the found category
      return category.id;
    } catch (e) {
      // Return -1 if no category is found
      print('Category not found: $e');
      return -1;
    }
  }
  Future<List<Category>> getAllCategories() async {
    final url = Uri.parse('$baseUrl/category/getall');
    try {
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // Check if the status code indicates a successful response
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          // Parse JSON data
          var responseData = jsonDecode(response.body);
          print('categ: ${responseData}');
          List<Category> categories = responseData.map((data) => Category.fromJson(data)).toList();
          return categories;
        } else {
          print('Response body is empty');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error at categ: $e');
    }
    return [Category(name: 'Art', description: '', id: 1),];
  }
  Future<bool> updateBlog({required int blogID,required Blog blog})async{
    final url = Uri.parse('http://bloggy.runasp.net/api/post/Update/$blogID');
    try {
      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Add this line
        },
        body: jsonEncode({
          //'postDto': {
          'title': blog.title,
          'content': blog.content,
          //'img': null,
          //'comments':[],
          'timeToRead': blog.timeToRead,
          'categoryId': blog.categoryID,
          //}
        }),
      );

      // Check if the status code indicates a successful response
      if (response.statusCode == 200) {
        print('Blog updated successfully');
        return true;
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Print the response body for debugging
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }
    void deleteBlog(int blogID)async{
      print(blogID);
      final url = Uri.parse('http://bloggy.runasp.net/api/post/Delete/$blogID'); // Correct endpoint
      try {
        var response = await http.delete(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );

        // Check if the status code indicates a successful response
        if (response.statusCode == 200) {
          print('Blog deleted successfully');
        } else {
          print('Failed with status code: ${response.statusCode}');
          print('Response body: ${response.body}'); // Print the response body for debugging
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    Future<List<dynamic>> fetchBlogs() async {
      final url = 'http://bloggy.runasp.net/api/post/getall';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Send the token
        },
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var items = responseBody['items'] as List; // Get the 'items' list

        // Map the items to a list of Blog objects
        List<Blog> blogs = items.map((item) => Blog.fromJson(item)).toList();
        return [responseBody ['pageNumber'] as int,
          responseBody ['pageSize'] as int,
          responseBody ['totalPosts'] as int,
          responseBody ['totalPages'] as int,
          blogs,
        ];
        // Handle the blogs data
      }
      return [];
    }
}
