import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_backlog_app/dashboard_page.dart';
import 'package:game_backlog_app/user_data.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView, required this.userData,});

  final Function toggleView;
  final UserData userData;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

        title: const Text("Register Page"),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Have an account? ",
              style: TextStyle(
                  color: Colors.pink),
            ),
            GestureDetector(
              onTap: () {
                widget.toggleView();
              },
              child: const Text("Sign In",
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
              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email.text,
                password: password.text,
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
              } else if (e.code == 'email-already-in-use') {
              }
            } catch (e) {
            }
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                DashboardPage(title: "Favorites", userData: widget.userData)), (Route<dynamic> route) => false);
          },
          child: const Text('Register'),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
            child: const Text("You are not required to enter a real email or password.\n"
                "This information is just for associating an account with data "
                "that is saved to a cloud database and will not be shared with anyone.\n"
                "Make sure to enter an email that could be valid\n"
                "by including an @ and an email domain.",
              style: TextStyle(
                color: Colors.black,
                  fontSize: 15),)
        ),

      ], // children
      ),
    );
  }
}