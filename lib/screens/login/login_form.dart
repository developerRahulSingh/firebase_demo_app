import 'package:FirebaseDemoApp/auth/firebase_auth.dart';
import 'package:FirebaseDemoApp/screens/home_screen.dart';
import 'package:FirebaseDemoApp/screens/register/register_screen.dart';
import 'package:FirebaseDemoApp/widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email, password;
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
              height: 10,
            ),
            GradientButton(
              width: 150,
              height: 45,
              onPressed: () {
                var signIn = context.read<FirebaseAuthService>().signIn(
                      email: email.trim(),
                      password: password.trim(),
                    );
                print('Data ==>> ${signIn.toString() == 'Sign In'}');
                print('Data ==>> $signIn');
//                if (signIn.toString() == 'Sign In') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return HomeScreen();
                    },
                  ),
                );
//                } return null;
              },
              text: Text(
                'LogIn',
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
            GradientButton(
              width: 150,
              height: 45,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return RegisterScreen();
                }));
              },
              text: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//  void _onEmailChange() {
//    _loginBloc.add(LoginEmailChange(email: _emailController.text));
//  }
//
//  void _onPasswordChange() {
//    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
//  }
//
//  void _onFormSubmitted() {
//    _loginBloc.add(LoginWithCredentialsPressed(
//        email: _emailController.text, password: _passwordController.text));
//  }
}
