import 'dart:async';
import 'package:blog/sign_up.dart';
import 'package:flutter/material.dart';
import 'service.dart';
import 'blogs_and_categories/loggedin_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isValidPassword = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final AuthService _authService = AuthService();
  final BlogService service = BlogService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await _authService.loginUser(email, password);
      if (response.statusCode == 200) {
        //Timer(Duration(seconds: 0), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoggedinPage()),
          );
        //});
      } else {
        debugPrint('${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Login'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>SignUpPage()));

            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white), // White text color
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));

            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white), // White text color
            ),
          ),
        ],
        backgroundColor: Colors.blue, // You can change the AppBar color
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.blue[200]),
          padding:  EdgeInsets.all(20.0),
          width: 350,
          height: 270,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(

                  decoration: InputDecoration(
                    /*border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,*/
                    labelText: 'Email',

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// /*
//
// void _logout() async {
//   final String token = 'your_saved_token';
//   await _authService.logoutUser(token);
//   // Navigate back to login screen or handle UI changes
// }
// */
//
//
// /*
// void validatePassword() {
//
//   setState(() {
//     //isValidPassword = _passwordController.text.isValidPassword();
//   });
// }*/