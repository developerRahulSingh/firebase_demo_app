import 'package:FirebaseDemoApp/auth/firebase_auth.dart';
import 'package:FirebaseDemoApp/screens/login/login_form.dart';
import 'package:FirebaseDemoApp/widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email, password, username;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: "User Name",
              ),
              keyboardType: TextInputType.name,
              autocorrect: false,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Category is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Category is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: "Password",
              ),
              obscureText: true,
              autocorrect: false,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Category is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            GradientButton(
              width: 150,
              height: 45,
              onPressed: () {
                context.read<FirebaseAuthService>().signUp(
                      email: email.trim(),
                      password: password.trim(),
                      username: username,
                    );
                return LoginForm();
              },
              text: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
