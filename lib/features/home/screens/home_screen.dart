import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart/cart_screen.dart';
import '../../profile/profile_screen.dart';
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
        'price': (i + 5) * 99.99, // Цены от 499.95 до 1399.86
        'imageUrl': _mockImages[i],
        'isNew': i % 3 == 0, // Каждый третий товар - новинка
        'isBest': i % 2 == 0, // Каждый второй товар - лучший
        'brand': ['Santarelli', 'LuxTime', 'ChronoMaster'][i % 3], // Чередуем бренды
        'material': ['Нержавеющая сталь', 'Титановый сплав', 'Керамика'][i % 3],
        'waterResistant': ['50m', '100m', '200m'][i % 3],
      };
    });
  }

  List<Map<String, dynamic>> _filterProducts(List<Map<String, dynamic>> products) {
    if (_isSearching && _searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      return products.where((p) =>
          p['title'].toString().toLowerCase().contains(query)).toList();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();
    final allProducts = _generateProducts(_mockImages.length); // Используем длину списка изображений
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
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        backgroundColor: theme.cardColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Избранное'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Корзина'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
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
                Text(
                  'SANTARELLI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
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