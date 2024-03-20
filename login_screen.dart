import 'package:flutter/material.dart';
import 'utils/database.dart'; // Correct the path based on your project structure
import 'models/user.dart'; // Correct the path based on your project structure

enum AuthMode { login, signup }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _authMode = AuthMode.login;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  void _switchAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;
    });
  }

  void _submit() async {
    // Implement your submission logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_authMode == AuthMode.login ? 'Login' : 'Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_authMode == AuthMode.signup)
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
              if (_authMode == AuthMode.signup)
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (_authMode == AuthMode.signup)
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_authMode == AuthMode.login ? 'Login' : 'Sign Up'),
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_authMode == AuthMode.login ? 'Create New Account' : 'I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
