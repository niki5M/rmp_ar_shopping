import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final orderProvider = Provider.of<OrderHistoryProvider>(context, listen: false);
    final primaryColor = const Color(0xFF9FBAF1);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _buildUserInfo(),
              const SizedBox(height: 32),
              _buildSettingsCard(context, primaryColor),
              const SizedBox(height: 16),
              _buildThemeSwitchCard(themeProvider, primaryColor),
              const SizedBox(height: 24),
              _buildLogoutButton(context, primaryColor),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          'Райан Гослинг',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ryan.gosling@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.edit,
              title: 'Редактировать профиль',
              color: primaryColor,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildListTile(
              icon: Icons.history,
              title: 'История заказов',
              color: primaryColor,
              onTap: () => _navigateToOrderHistory(context),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildListTile(
              icon: Icons.favorite,
              title: 'Избранное',
              color: primaryColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOrderHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderHistoryScreen(),
      ),
    );
  }

  Widget _buildThemeSwitchCard(ThemeProvider themeProvider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.notifications,
              title: 'Уведомления',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              color: primaryColor,
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildListTile(
              icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Темная тема',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeColor: primaryColor,
              ),
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _showLogoutDialog(context),
          child: const Text(
            'Выйти из аккаунта',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтверждение'),
        content: const Text('Вы действительно хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Логика выхода
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Новый экран истории заказов
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderHistoryProvider>(context);
    final orders = orderProvider.orders;
    final primaryColor = const Color(0xFF9FBAF1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
      ),
      body: orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Нет истории заказов',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Заказ #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Chip(
                        backgroundColor: primaryColor.withOpacity(0.2),
                        label: Text(
                          order.status,
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.date} • ${order.items.length} товаров',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.totalPrice.toStringAsFixed(2)} ₽',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderHistoryProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void loadOrders() async {
    // Здесь может быть загрузка из API или локального хранилища
    _orders = [
      Order(
        id: '1001',
        date: '15 мая 2023',
        status: 'Доставлен',
        items: ['Товар 1', 'Товар 2'],
        totalPrice: 5499.0,
      ),
      Order(
        id: '1000',
        date: '1 мая 2023',
        status: 'Отменен',
        items: ['Товар 3'],
        totalPrice: 2499.0,
      ),
    ];
    notifyListeners();
  }
}

class Order {
  final String id;
  final String date;
  final String status;
  final List<String> items;
  final double totalPrice;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.totalPrice,
  });
}