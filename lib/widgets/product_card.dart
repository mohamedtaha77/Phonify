import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../l10n/app_localizations.dart';
import '../screens/product/product_details_screen.dart';
import '../utils/constants.dart';

class ProductCard extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}


class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final localization = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Semantics(
            label: 'Product card for ${widget.title}. Tap for details.',
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      productId: widget.id,
                      title: widget.title,
                      imageUrl: widget.imageUrl,
                      price: widget.price,
                      description: widget.description,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(
                  vertical: AppPadding.medium,
                  horizontal: AppPadding.medium,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                shadowColor: AppColors.shadowColor,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.white,
                            child: Image.asset(
                              widget.imageUrl,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppPadding.medium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.title, style: AppTextStyles.heading),
                              const SizedBox(height: AppPadding.small),
                              Text('EGP ${widget.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: AppPadding.medium),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(
                            favoritesProvider.isFavorite(widget.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => favoritesProvider.toggleFavoriteStatus(widget.id),
                          tooltip: favoritesProvider.isFavorite(widget.id)
                              ? localization.remove_from_favorites
                              : localization.addToFavorites,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          onPressed: () {
                            cartProvider.addItem(
                              widget.id,
                              widget.title,
                              widget.price,
                              imageUrl: widget.imageUrl,
                              description: widget.description,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localization.added_to_cart)),
                            );
                          },
                          tooltip: localization.add_to_cart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
