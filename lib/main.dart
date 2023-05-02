import 'package:game_backlog_app/register.dart';
import 'package:game_backlog_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:game_backlog_app/user_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UserData userData = UserData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Backlog',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Favorites', userData: userData,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.userData});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final UserData userData;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.userChanges().listen((User? user) {
    //   if (user != null) {
    //     return DashboardPage(title: "Favorites", userData: widget.userData);
    //     }
    //   })
    // if (FirebaseAuth.instance.currentUser != null) {
    //   return DashboardPage(title: "Favorites", userData: widget.userData);
    // } else
      if (showSignIn) {
      return SignIn(
        toggleView: toggleView,
        userData: widget.userData,);
    } else {
      return Register(
        toggleView: toggleView,
        userData: widget.userData,);
    }
  }
}
