import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../l10n/app_localizations.dart';
import '../product/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allProducts;

  const FavoritesScreen({Key? key, required this.allProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final localization = AppLocalizations.of(context)!;

    final favoriteItems = favoritesProvider.favoriteItems(allProducts);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.favorites),
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? Center(child: Text(localization.favorites_empty))
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final product = favoriteItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Image.asset(
                product['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
              ),
              title: Text(product['title']),
              subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  favoritesProvider.toggleFavoriteStatus(product['id']);
                },
                tooltip: 'Remove from favorites',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      productId: product['id'],
                      title: product['title'],
                      imageUrl: product['imageUrl'],
                      price: product['price'],
                      description: product['description'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}