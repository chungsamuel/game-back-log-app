import 'package:flutter/material.dart';
import 'package:game_backlog_app/dashboard_page.dart';
import 'package:game_backlog_app/user_data.dart';
import 'package:favorite_button/favorite_button.dart';

class GameDetailsPage extends StatefulWidget {
  const GameDetailsPage({super.key, required this.title, required this.jsonResponse, required this.coverID, required this.index, required this.userData, required this.favoriteKey,});

  final String title;
  final List<Map<String, dynamic>> jsonResponse;
  final String coverID;
  final int index;
  final UserData userData;
  final int favoriteKey;

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {

  void _incrementCounter(String favorite, String passSummary) {
    String temp = widget.jsonResponse[widget.index]['id'].toString();
    widget.userData.buildMap(favorite, passSummary);
    if (widget.favoriteKey == 1 && widget.userData.checkIDExists(temp) == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(title: "Favorites", userData: widget.userData,)),
      );
    } else {
      setState(() {});
    }
  }

  bool negateBool(bool value) {
    return !value;
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.jsonResponse[widget.index]['name'];
    String rating;
    Color circularColor = Colors.red;
    double circularBar = 0;
    if (widget.jsonResponse[widget.index]['rating'] == null) {
      rating = "N/A";
    } else if (widget.jsonResponse[widget.index]['rating'] == "N/A") {
      rating = "N/A";
    } else {
      rating = widget.jsonResponse[widget.index]['rating'].toString();
      // rating = longRating.toStringAsFixed(2);
      if (rating.length > 2) {
        rating = rating.substring(0, 2);
      }
      circularBar = double.parse(rating)/100;
      if (circularBar >= 0.75) {
        circularColor = Colors.green;
      } else if (circularBar  >= 0.5) {
        circularColor = Colors.yellow;
      }
    }
    String summary;
    if (widget.jsonResponse[widget.index]['summary'] == null) {
      summary = "This game is missing a summary.";
    } else {
      summary = widget.jsonResponse[widget.index]['summary'];
    }
    String url = widget.jsonResponse[widget.index]['url'];
    String gameID = widget.jsonResponse[widget.index]['id'].toString();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 38, 54),
        title: Text(widget.title), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.highlight_remove), // The "-" icon
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage(title: "Favorites", userData: widget.userData,)),
            );
          }, // onPressed
        ),
      ],
      ),
      body: SingleChildScrollView(
        child: Column (
          children: <Widget>[
            Container(
              child: Image(
                image: NetworkImage('https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${widget.coverID}.png'),
              ),
            ),
            Container(
              child: Text(name,
                  style: const TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 227, 38, 54))
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: widget.userData.checkIDExists(gameID) ? Border.all(color: const Color.fromARGB(255, 227, 38, 54)): Border.all(color: Colors.blueGrey.withOpacity(0.25))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: widget.userData.checkIDExists(gameID) ? const Text("Favorited", style: TextStyle(color: Colors.white),) :
                          const Text("Favorite?", style: TextStyle(color: Colors.white),),
                        ),
                        Container(
                          child: FavoriteButton(
                            isFavorite: widget.userData.checkIDExists(gameID),
                            valueChanged: (_isFavorite){
                              _incrementCounter('$name,$gameID,${widget.coverID},$rating,$url', '$summary');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                  // margin: EdgeInsets.only(left: 20, right: 10),
                  child: Text('Rating: $rating',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13),
                  ),
                ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 20),
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(circularColor),
                    value: circularBar,
                  ),
                ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(20),
              child: Text('Summary:\n$summary',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    height: 1.3),
              ),
            ),
            Container(
              child: Text(url,
                  style: const TextStyle(fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)
              ),
            ),
          ],
          ),
        ),
      );
  }
}


