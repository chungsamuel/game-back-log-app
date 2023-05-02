import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_backlog_app/main.dart';
import 'package:game_backlog_app/user_data.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.userData,});

  final UserData userData;

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Account\nServices',
              style: TextStyle(fontSize: 30),
            ),
          ),
          ListTile(
            title: Text('Signed in as: ${FirebaseAuth.instance.currentUser?.email}'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.userChanges().listen((User? user) {
                if (user == null) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        MyHomePage(title: "title", userData: userData)), (Route<dynamic> route) => false);
                  });
                }
              });
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}