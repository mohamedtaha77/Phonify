import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteProductIds = {};

  Set<String> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavoriteStatus(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProductIds.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> favoriteItems(List<Map<String, dynamic>> allProducts) {
    return allProducts.where((product) => _favoriteProductIds.contains(product['id'])).toList();
  }
}