import 'dart:collection';
import 'dart:developer';

class UserData{
  List<String> favorites = [];
  List<Map<String, dynamic>> map = [];
  int count = 0;
  int removeIndex = 0;
  bool runOnce = false;
  bool forceLogin = false;

  void buildMap(String favorite, String passSummary) {
    List<String> substrings = favorite.split(",");
    String name = substrings[0];
    String id = substrings[1];
    String coverID = substrings[2];
    String rating = substrings[3];
    String url = substrings[4];
    String summary = passSummary;
    log(summary);
    if (checkIDExists(id)) {
      removeGame(removeIndex);
    } else {
      count++;
      Map<String, dynamic> data = HashMap();
      data.addAll({"name": name, "id": id, "coverID": coverID, "rating": rating, "url": url ,"summary": summary});
      map.add(data);
    }
  }

  bool checkIDExists(String id) {
    bool idExists = false;
    for (int index = 0; index < count; index++) {
      Map<String, dynamic> data = HashMap();
      data = map[index];
      idExists = data.containsValue(id);
      if (idExists) {
        removeIndex = index;
        break;
      }
    }

    return idExists;
  }

  void removeGame(int index) {
    map.remove(map[index]);
    count--;
  }

  int getGameCount() {
    return count;
  }

  List<Map<String, dynamic>> getMap() {
    return map;
  }

  void addMap(List<Map<String, dynamic>> firebaseMap) {
    if (firebaseMap.isNotEmpty) {
      // List<Map<String, dynamic>> tempMap = firebaseMap;
      // MergeSortAlgo ob = MergeSortAlgo();
      // ob.sort();
      // List<Map<String, dynamic>> reorderedMap = [];
      // List<Map<String, dynamic>> tempMap = firebaseMap;
      // while (reorderedMap.length <= firebaseMap.length) {
      //   for (int i = 0; i < tempMap.length; i++) {
      //     int index = tempMap[i]['backlogIndex'];
      //     if (index == i) {
      //       reorderedMap.add(tempMap[i]);
      //     }
      //   }
      // }
      map = firebaseMap;
      count = firebaseMap.length;
    }
  }

  bool runMeOnce() {
    return runOnce;
  }

  bool forceUserLogin() {
    return forceLogin;
  }

}

// class MergeSortAlgo {
//   void merge() {
//
//   }
//
//   void sort() {
//
//   }
// }