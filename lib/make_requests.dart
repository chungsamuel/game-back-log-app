import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:async';

class igdb {
  // static String token = "906gimfn5eemnwtwvt6lt2ns5mjydh";
  static late String token;
  static final games = Uri.parse('https://api.igdb.com/v4/games');
  static final covers = Uri.parse('https://api.igdb.com/v4/covers');
  // static final headers = {
  //   'Content-Type': 'text/plain',
  //   'Authorization': 'Bearer d51tghh6zyndgch4n3ac2p2m09zs6j',
  //   'Client-ID': '3lc6koux5x1u6uzak7s0i52cbrj2r0',
  // };
  static final params = {
    'client_id': '3lc6koux5x1u6uzak7s0i52cbrj2r0',
    'client_secret': 'w8mt1llbdqkbyzfqpqkn6m43xqefh7',
    'grant_type': 'client_credentials',
  };

  static Future<void> getBearerToken() async {
    final bearerUri = Uri.https('id.twitch.tv', '/oauth2/token', params);
    Map<String, dynamic> decodedResponse = {};

    final response = await http.post(bearerUri);
    decodedResponse = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    token = decodedResponse['access_token'];
    print(token);
  }

  static Future<List<Map<String, dynamic>>> searchGame(String searchTerm) async {
    // getBearerToken();
    List<Map<String, dynamic>> jsonResponse = [];
     final headers = {
      'Content-Type': 'text/plain',
      'Authorization': 'Bearer $token',
      'Client-ID': '3lc6koux5x1u6uzak7s0i52cbrj2r0',
    };

    var getGame = await http.post(
      games,
      headers: headers,
      body: 'fields name, rating, summary, url, cover; limit 500; search "$searchTerm";',
    );
    jsonResponse = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(getGame.bodyBytes)));
    return jsonResponse;
  }

  static Future<List<Map<String, dynamic>>> searchCover(int coverID) async{
    // getBearerToken();
    List<Map<String, dynamic>> jsonResponse = [];
    final headers = {
      'Content-Type': 'text/plain',
      'Authorization': 'Bearer $token',
      'Client-ID': '3lc6koux5x1u6uzak7s0i52cbrj2r0',
    };

    var getCoverID = await http.post(
      covers,
      headers: headers,
      body: 'fields image_id; where id = $coverID;',
    );
    jsonResponse = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(getCoverID.bodyBytes)));

    return jsonResponse;
  }

  static Future<List<Map<String, dynamic>>> searchID(String gameID) async {
    // getBearerToken();
    List<Map<String, dynamic>> jsonResponse = [];
    final headers = {
      'Content-Type': 'text/plain',
      'Authorization': 'Bearer $token',
      'Client-ID': '3lc6koux5x1u6uzak7s0i52cbrj2r0',
    };

    var getGameWID = await http.post(
      games,
      headers: headers,
      body: 'fields name, rating, summary, url, cover; where id = ($gameID);',
    );
    jsonResponse = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(getGameWID.bodyBytes)));
    return jsonResponse;
  }
}