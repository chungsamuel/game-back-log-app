import 'package:game_backlog_app/make_requests.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_backlog_app/user_data.dart';
import 'package:game_backlog_app/game_Details_Page.dart';

class PostRequests extends StatefulWidget {
  const PostRequests({super.key, required this.title, required this.userData,});

  final String title;
  final UserData userData;

  @override
  State<PostRequests> createState() => _PostRequestsState();
}

class _PostRequestsState extends State<PostRequests> {
  List<Map<String, dynamic>> map = [];
  List<Map<String, dynamic>> test3 = [];
  List<String> allGames = [];
  List<String> allCovers = [];
  List<String> allIDs = [];
  late String type;
  late String info;
  int gameCount = 0;
  int favoriteKey = 2;
  bool isLoading = false;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    igdb.getBearerToken();
  }

  makePostRequest() async {
    final search = myController.text;
    setState(() {isLoading = true;});
    Future<List<Map<String, dynamic>>> futureResponse = igdb.searchGame(search);
    map = await futureResponse;
    gameCount = map.length;
    for (int i = 0; i < gameCount; i++) {
      info = map[i]['name'].toString();
      allGames.add(info);
      if (map[i]['cover'] == null) {
        type = "nocover";
        allCovers.add(type);
      } else {
        int coverID = map[i]['cover'];
        Future<List<Map<String, dynamic>>> futureResponse3 = igdb.searchCover(coverID);
        test3 = await futureResponse3;
        type = test3[0]['image_id'].toString();
        allCovers.add(type);
      }
    }
    setState(() {isLoading = false;});
  }

  late String text;
  final _formKey = GlobalKey<FormState>();

  showWidget() {
    if (isLoading == true) {
      return Container(alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Color.fromARGB(255, 71, 225, 12),),
      );
    }
    if (gameCount > 0) {
      return ListView.builder(
          itemCount: gameCount,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image(
                image: NetworkImage('https://images.igdb.com/igdb/image/upload/t_thumb/${allCovers[index]}.png'),
              ),
              title: Text(allGames[index],
                style: const TextStyle(
                    color: Colors.white, fontSize: 15),
              ),

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
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 225, 12),
        title: Form(
          key: _formKey,
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                // icon: Icon(Icons.search),
                // contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                contentPadding: EdgeInsets.all(8),
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                hintText: 'What game did you want to find?',
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
                  allGames = [];
                  allCovers = [];
                  makePostRequest();
                }
              },
        ),
          ),
        ),
      ),
      body: showWidget(),
      bottomNavigationBar: Text('                                         '
          'Results: $gameCount',
          style: const TextStyle(
          color: Colors.white,
              fontSize: 15,
          )),
    );
  }
}