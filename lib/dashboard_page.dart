import 'package:flutter/material.dart';
import 'package:game_backlog_app/drawer.dart';
import 'package:game_backlog_app/user_data.dart';
import 'package:game_backlog_app/game_Details_Page.dart';
import 'package:game_backlog_app/post_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title, required this.userData,});

  final String title;
  final UserData userData;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> allGames = [];
  List<String> allCovers = [];
  List<String> allIDs = [];
  List<Map<String, dynamic>> jsonResponse = [];
  List<Map<String, dynamic>> map = [];
  String type = "";
  int favoriteKey = 1;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    bool runOnce = widget.userData.runMeOnce();
    if (runOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final snapshot = await db.collection("${FirebaseAuth.instance.currentUser?.uid}").get();
        var data = snapshot.docs.map((doc) => doc.data()).toList();
        widget.userData.addMap(data);
        widget.userData.runOnce = true;
        setState(() {});
      });
    }
  } // initState

  makeListView() {
    if (widget.userData.getGameCount() > 0) {
      showWidget();
      return
        ReorderableListView(
          padding: const EdgeInsets.all(10),
          header: Text('Games in backlog: ${allGames.length}', style: const TextStyle(color: Colors.white),),
          children: <Widget>[
            for (int index = 0; index < allGames.length; index += 1)
              Card(
                color: const Color.fromARGB(235, 0, 116, 183),
                key: Key(allGames[index]),
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Image(
                    image: NetworkImage('https://images.igdb.com/igdb/image/upload/t_thumb/${allCovers[index]}.png'),
                  ),
                  // tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
                  title: Text(allGames[index], style: const TextStyle(color: Colors.white),),
                  trailing: const Icon(Icons.more_vert),
                  // tileColor: const Color.fromARGB(235, 20, 93, 160),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameDetailsPage(
                        title: "Game Details",
                        jsonResponse: map,
                        coverID: allCovers[index],
                        index: index,
                        userData: widget.userData,
                        favoriteKey: favoriteKey,)),
                    );
                  },
                ),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              String games = allGames.removeAt(oldIndex);
              allGames.insert(newIndex, games);
              Map<String, dynamic> thing = map.removeAt(oldIndex);
              map.insert(newIndex, thing);
              String coversthing = allCovers.removeAt(oldIndex);
              allCovers.insert(newIndex, coversthing);
            });
          },);
    } else {
      return Container(alignment: Alignment.center,
        child: const Text('You have no games in backlog!\nDare to start a new one? 😈',
          style: TextStyle(
              color: Colors.white, fontSize: 20),),
      );
    }// if statement
  } // makeListView

  showWidget() {
    int gameCount = widget.userData.getGameCount();
    if (gameCount > 0) {
      map = widget.userData.getMap();
      allCovers = [];
      allGames = [];
      allIDs = [];
      jsonResponse = [];
      type = "";
      for (int i = 0; i < gameCount; i++) {
        String name = map[i]['name'];
        allGames.add(name);
        String coverID = map[i]['coverID'];
        allCovers.add(coverID);
        String gameID = map[i]['id'];
        allIDs.add(gameID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 96, 163, 217),
      drawer: MyDrawer(userData: widget.userData,),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 59, 115),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                final instance = FirebaseFirestore.instance;
                final batch = instance.batch();
                var collection = instance.collection("${FirebaseAuth.instance.currentUser?.uid}");
                var snapshots = await collection.get();
                for (var doc in snapshots.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();
                for (int i = 0; i < map.length; i++) {
                  log(map[i].toString());
                  db.collection("${FirebaseAuth.instance.currentUser?.uid}").add(map[i]);
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostRequests(title: 'Post Requests Page', userData: widget.userData,)),
              );
            },
          ),
        ],
      ),
      body: makeListView(),
    );
  }
}
