import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_backlog_app/dashboard_page.dart';
import 'package:game_backlog_app/user_data.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView, required this.userData,});

  final Function toggleView;
  final UserData userData;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Sign In Page"),
      ),
      body: Column(children: [
        Form(
          key: _formKey,
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                // contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                contentPadding: EdgeInsets.all(8),
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
                // labelText: 'Search Games',
              ),
              // The validator receives the text that the user has entered.
              validator: (String ? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onFieldSubmitted: (String ? value) {
                if (_formKey.currentState!.validate()) {

                }
              },
            ),
          ),
        ),
        Form(
          key: _formKey2,
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: password,
              decoration: const InputDecoration(
                // contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                contentPadding: EdgeInsets.all(8),
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                hintText: 'Password',
              ),
              // The validator receives the text that the user has entered.
              validator: (String ? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onFieldSubmitted: (String ? value) {
                if (_formKey.currentState!.validate()) {

                }
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Don't have an account? ",
              style: TextStyle(
                  color: Colors.pink),
            ),
            GestureDetector(
              onTap: () {
                widget.toggleView();
              },
              child: const Text("Sign Up",
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,),),
            ),
          ],),
        ElevatedButton(
          style: const ButtonStyle(
          ),
          onPressed: () async {
            try {
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email.text,
                  password: password.text,
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
              } else if (e.code == 'wrong-password') {
              }
            }
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                DashboardPage(title: "Favorites", userData: widget.userData)), (Route<dynamic> route) => false);
          },
          child: const Text('Sign In'),
        ),
      ], // children
      ),
    );
  }
}