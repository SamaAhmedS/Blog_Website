import 'package:flutter/material.dart';
import 'service.dart';
import 'login.dart';


class SignUpPage extends StatefulWidget {

  //SignUpPage({required this.myAppBar});  //
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmedPassword = '';
  String name = '';
  final AuthService _authService = AuthService();

  void _register() async {
    final response = await _authService.registerUser(name: 'sama', email: 'samaa2772@gmail.com', password: '100#02448910Sama', confirmedPassword: '100#02448910Sama');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await _authService.registerUser(name: 'sama', email: 'samaa2772@gmail.com', password: '100#02518910Sama', confirmedPassword: '100#02518910Sama');
      //final response = await _authService.registerUser(name: name, email: email, password: password, confirmedPassword: confirmedPassword);

      if (response.statusCode == 200) {

        debugPrint('User registered successfully');

        // Ensure widget is still mounted
        //if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        //}
      } else {

        debugPrint('User registered ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar myAppBar = AppBar(
      title: const Text('Sign Up'),
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
    );
    return Scaffold(
      appBar: myAppBar,
      body: Center(
        child: Container(
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.blue[200]),

          padding:  EdgeInsets.all(20.0),
          //color: Colors.white,
          width: 350,
          height: 400,
          child: Form(
            key: _formKey,

            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  //obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
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
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the confirmed password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmedPassword = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Sign Up'),
                ),
                /*SizedBox(height: 20),
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Login', style: TextStyle(color: Colors.red))
                )*/
              ],
            ),
          ),
        ),

      ),
    );
  }
}
