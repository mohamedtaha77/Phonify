import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/offer_tile.dart';
import '../../widgets/product_card.dart';
import '../../l10n/app_localizations.dart';
import '../favorites/favorites_screen.dart';
import '../cart/cart_screen.dart';
import '../../providers/cart_provider.dart';
import '../../main.dart';

class HoverScaleWidget extends StatefulWidget {
  final Widget child;
  final double scaleFactor;
  final Duration duration;

  const HoverScaleWidget({
    Key? key,
    required this.child,
    this.scaleFactor = 1.05,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _HoverScaleWidgetState createState() => _HoverScaleWidgetState();
}

class _HoverScaleWidgetState extends State<HoverScaleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    setState(() => _hovering = true);
    _controller.forward();
  }

  void _onExit(PointerEvent details) {
    setState(() => _hovering = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(scale: _animation.value, child: child),
        child: widget.child,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final List<String> bannerImagePaths = [
      'assets/images/banner1.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
      'assets/images/banner4.jpg',
      'assets/images/banner5.jpg',
      'assets/images/banner6.jpg',
    ];

    final List<Map<String, String>> hotOffers = [
      {
        'title': localization.offerTitle,
        'subtitle': localization.offerSubtitle,
        'badge': '50% OFF',
      },
      {
        'title': localization.buy1Get1Title,
        'subtitle': localization.buy1Get1Subtitle,
        'badge': 'B1G1',
      },
      {
        'title': localization.megaDiscountTitle,
        'subtitle': localization.megaDiscountSubtitle,
        'badge': '70% OFF',
      },
      {
        'title': localization.freeDeliveryTitle,
        'subtitle': localization.freeDeliverySubtitle,
        'badge': 'FREE SHIP',
      },
      {
        'title': localization.flashSaleTitle,
        'subtitle': localization.flashSaleSubtitle,
        'badge': 'FLASH',
      },
    ];


    final List<Map<String, dynamic>> products = [
      {
        'id': '1',
        'title': 'Huawei P60 Pro',
        'description': '..',
        'imageUrl': 'assets/images/product1.jpg',
        'price': 57999.99,
      },
      {
        'id': '2',
        'title': 'iPhone 16 Pro Max',
        'description': '..',
        'imageUrl': 'assets/images/product2.jpg',
        'price': 62999.99,
      },
      {
        'id': '3',
        'title': 'S25 Ultra',
        'description': '..',
        'imageUrl': 'assets/images/product3.jpg',
        'price': 66999.99,
      },
      {
        'id': '4',
        'title': 'Oppo Find N5',
        'description': '..',
        'imageUrl': 'assets/images/product4.jpg',
        'price': 119999.99,
      },
      {
        'id': '5',
        'title': 'HONOR Magic V3',
        'description': '..',
        'imageUrl': 'assets/images/product5.jpg',
        'price': 73999.99,
      },
      {
        'id': '6',
        'title': 'Vivo V50',
        'description': '..',
        'imageUrl': 'assets/images/product6.jpg',
        'price': 22999.99,
      },
      {
        'id': '7',
        'title': 'Xiaomi 14T',
        'description': '..',
        'imageUrl': 'assets/images/product7.jpg',
        'price': 28999.99,
      },
      {
        'id': '8',
        'title': 'Google Pixel 9 Pro',
        'description': '..',
        'imageUrl': 'assets/images/product8.jpg',
        'price': 40999.99,
      },
      {
        'id': '9',
        'title': 'Infinix GT 30 Pro',
        'description': '..',
        'imageUrl': 'assets/images/product9.jpg',
        'price': 18999.99,
      },
      {
        'id': '10',
        'title': 'Realme GT 7',
        'description': '..',
        'imageUrl': 'assets/images/product10.jpg',
        'price': 38999.99,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.products),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Toggle Language',
            onPressed: () {
              final currentLocale = Localizations.localeOf(context);
              final newLocale = currentLocale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              FlutterShoppingApp.setLocale(context, newLocale);
            },
          ),

          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: localization.favorites,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(allProducts: products),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: localization.cart,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 800 ? 48.0 : 16.0;

          int crossAxisCount;
          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 5;
          } else if (constraints.maxWidth >= 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth >= 600) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }

          final cardWidth =
              (constraints.maxWidth - (crossAxisCount - 1) * 12 - horizontalPadding * 2) / crossAxisCount;
          const cardHeight = 360;
          final childAspectRatio = cardWidth / cardHeight;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bannerImagePaths.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: AspectRatio(
                          aspectRatio: 535 / 457,
                          child: HoverScaleWidget(
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                bannerImagePaths[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  localization.offers,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  itemCount: hotOffers.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final offer = hotOffers[index];
                    return HoverScaleWidget(
                      child: OfferTile(
                        title: offer['title']!,
                        subtitle: offer['subtitle']!,
                        badgeText: offer['badge']!,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  localization.products,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      id: product['id'],
                      title: product['title'],
                      description: product['description'],
                      imageUrl: product['imageUrl'],
                      price: product['price'],
                      onAddToCart: () {
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        cartProvider.addItem(product['id'], product['title'], product['price']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.added_to_cart)),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
