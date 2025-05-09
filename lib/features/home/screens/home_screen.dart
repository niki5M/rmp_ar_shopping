import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart/cart_screen.dart';
import 'profile_screen.dart';
import '../widgets/product.dart';
import '../widgets/product_item.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/search_app_bar.dart';
import '../../cart/cart_provider.dart';
import '../../favorites/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedFilter = 'Все';
  final List<String> _filters = ['Все', 'Новая коллекция', 'Лучшее'];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Список мок-изображений для товаров
  final List<String> _mockImages = [
    'https://img.freepik.com/premium-photo/sports-watch-white-color_729316-1.jpg?ga=GA1.1.456033172.1742466676&semt=ais_hybrid&w=740',
    'https://img.freepik.com/free-photo/elegant-watch-with-silver-golden-chain-isolated_181624-27080.jpg?t=st=1746477567~exp=1746481167~hmac=81bc7e787b5967c9e37fb957598667b5567f8285bf4de6faa65f576602d7c3db&w=1380',
    'https://img.freepik.com/free-photo/elegant-watch-with-silver-golden-chain-lights-isolated_181624-28442.jpg?t=st=1746477626~exp=1746481226~hmac=6029ee064d84d408e79ae18f9d275eb754428593b6417d1b350d8577781e671c&w=1060',
    'https://img.freepik.com/free-photo/stylish-golden-watch-white-surface_181624-27078.jpg?t=st=1746477663~exp=1746481263~hmac=61b882c6e4afea5fddb72bc42a5e1162ffbab152a05b4d4fa0d07f25fd6b2999&w=1060',
    'https://img.freepik.com/free-vector/modern-watch_23-2147517339.jpg?t=st=1746477692~exp=1746481292~hmac=21e9f4f33d23dd9cd3dab7f5a80625d58b4f71c151589e68a12f73471ef97ac1&w=1060',
    'https://img.freepik.com/premium-photo/wrist-watch-white-background_181020-748.jpg?w=1480',
    'https://img.freepik.com/premium-photo/women-s-wristwatch-black-closeup-isolated-white-background_554859-806.jpg?w=1800',
    'https://img.freepik.com/premium-photo/silvercolored-watch-white-background_343275-393.jpg?w=1800',
    'https://img.freepik.com/premium-photo/close-up-wristwatch-white-background_1048944-22919484.jpg?w=1800',
    'https://img.freepik.com/premium-photo/analog-fashion-watches-isolated-white-background_47469-280.jpg?w=1800',
  ];

  // Названия для часов с брендами и характеристиками
  final List<String> _productNames = [
    'SportX Pro (чёрный/красный)',
    'Elegance Gold (золотой)',
    'Chrono Silver (серебристый)',
    'Royal Classic (золотой)',
    'Modern Edge (чёрный)',
    'Premium Time (коричневый)',
    'Luxury Lady (чёрный)',
    'Silver Peak (серебристый)',
    'Executive Style (чёрный)',
    'Vintage Rose (розовое золото)',
  ];

  // Описания для часов
  final List<String> _productDescriptions = [
    'Спортивные часы с хронографом, водонепроницаемость 10ATM',
    'Элегантные золотые часы с кожаным ремешком',
    'Классические серебряные часы с металлическим браслетом',
    'Роскошные золотые часы с сапфировым стеклом',
    'Современные часы с минималистичным дизайном',
    'Премиальные часы с кожаным ремешком и датой',
    'Женские часы класса люкс с бриллиантами',
    'Серебряные часы с синим циферблатом',
    'Деловые часы с автоматическим механизмом',
    'Винтажные часы в розовом золоте',
  ];

  List<Map<String, dynamic>> _generateProducts(int count) {
    return List.generate(count, (i) {
      final id = i.toString();
      return {
        'id': id,
        'title': _productNames[i],
        'description': _productDescriptions[i],
        'price': (i + 86) * 99.99,
        'imageUrl': _mockImages[i],
        'isNew': i % 3 == 0,
        'isBest': i % 2 == 0,
        'brand': ['Santarelli', 'LuxTime', 'ChronoMaster'][i % 3],
        'material': ['Нержавеющая сталь', 'Титановый сплав', 'Керамика'][i % 3],
        'waterResistant': ['50m', '100m', '200m'][i % 3],
      };
    });
  }

  List<Map<String, dynamic>> _filterProducts(List<Map<String, dynamic>> products) {
    if (_isSearching && _searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      return products.where((p) =>
      p['title'].toString().toLowerCase().contains(query) ||
          p['description'].toString().toLowerCase().contains(query) ||
          p['brand'].toString().toLowerCase().contains(query)).toList();
    }

    switch (_selectedFilter) {
      case 'Новая коллекция':
        return products.where((p) => p['isNew'] as bool).toList();
      case 'Лучшее':
        return products.where((p) => p['isBest'] as bool).toList();
      default:
        return products;
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _handleSearchChanged(String query) {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();
    final allProducts = _generateProducts(_mockImages.length);
    final filteredProducts = _filterProducts(allProducts);

    final List<Widget> _pages = [
      _buildHomeTab(filteredProducts),
      const FavoritesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SearchAppBar(
        isSearching: _isSearching,
        searchController: _searchController,
        onToggleSearch: _toggleSearch,
        onCartPressed: () => _onTabTapped(2),
        cartItemCount: cart.itemCount,
        userName: 'Райан Гослинг',
        onSearchChanged: _handleSearchChanged,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: theme.cardColor,
            selectedItemColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
            unselectedItemColor: theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.6)
                : const Color(0xFF9FBAF1),

            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildBottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                isActive: _selectedIndex == 0,
              ),
              _buildBottomNavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                isActive: _selectedIndex == 1,
              ),
              _buildBottomNavItem(
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag,
                isActive: _selectedIndex == 2,
                badgeValue: cart.itemCount,
              ),
              _buildBottomNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isActive: _selectedIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required bool isActive,
    int? badgeValue,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              key: ValueKey(isActive ? 'active_$icon' : icon),
              size: 28,
              color: isActive
                  ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                  : (Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF9FBAF1)
                  : const Color(0xFF9FBAF1)),

            ),
          ),
          if (badgeValue != null && badgeValue > 0)
            Positioned(
              right: -8,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  badgeValue.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      label: '',
    );
  }

  Widget _buildHomeTab(List<Map<String, dynamic>> filteredProducts) {
    return Column(
      children: [
        if (!_isSearching)
          FilterChipRow(
            selectedFilter: _selectedFilter,
            filters: _filters,
            onFilterChanged: _onFilterChanged,
          ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey.shade200,
        ),
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
              ],
            ),
          ),
        Expanded(
          child: filteredProducts.isEmpty
              ? Center(
            child: Text(
              _isSearching && _searchController.text.isNotEmpty
                  ? 'Ничего не найдено'
                  : 'Нет товаров по выбранному фильтру',
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (ctx, i) => ProductItem(
              Product(
                id: filteredProducts[i]['id'],
                title: filteredProducts[i]['title'],
                price: filteredProducts[i]['price'],
                imageUrl: filteredProducts[i]['imageUrl'],
              ),
            ),
          ),
        ),
      ],
    );
  }
}