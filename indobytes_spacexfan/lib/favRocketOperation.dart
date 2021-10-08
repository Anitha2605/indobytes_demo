import 'package:flutter/cupertino.dart';

import 'allSpaceXrockets.dart';

class FavOp extends ChangeNotifier {
  List<Rocket> listOfRockets = [];
  List<int> favItemsIndexes = [];

  List<int> getFavItemsIndexes() {
    return favItemsIndexes;
  }

  void addIndex(int ind) {
    favItemsIndexes.add(ind);
    notifyListeners();
  }

  void removeIndex(int ind) {
    favItemsIndexes.removeWhere((element) => ind == element);
    notifyListeners();
  }

  List<Rocket> getFavRocList() {
    return listOfRockets;
  }

  void insertToFavList(Rocket rock) {
    listOfRockets.add(rock);
    notifyListeners();
  }

  void removeFromFavList(Rocket rock) {
    listOfRockets.removeWhere((element) => rock.id == element.id);
    notifyListeners();
  }
}
