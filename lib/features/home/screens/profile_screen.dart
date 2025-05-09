import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../cart/cart_item.dart';
import '../../order/order.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 32),
              _buildUserInfo(theme),
              const SizedBox(height: 32),
              _buildSettingsCard(context, theme),
              const SizedBox(height: 16),
              _buildThemeSwitchCard(themeProvider, theme),
              const SizedBox(height: 24),
              _buildLogoutButton(context, theme),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: theme.dividerColor,
          child: Icon(
            Icons.person,
            size: 48,
            color: theme.iconTheme.color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Райан Гослинг',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF9FBAF1)
                : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ryan.gosling@example.com',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.edit,
              title: 'Редактировать профиль',
              theme: theme,
              onTap: () {},
            ),
            Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
            _buildListTile(
              icon: Icons.history,
              title: 'История заказов',
              theme: theme,
              onTap: () => _navigateToOrderHistory(context),
            ),
            Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
            _buildListTile(
              icon: Icons.favorite,
              title: 'Избранное',
              theme: theme,
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

  Widget _buildThemeSwitchCard(ThemeProvider themeProvider, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.notifications,
              title: 'Уведомления',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: theme.brightness == Brightness.dark
                    ? const Color(0xFF9FBAF1)
                    : Colors.black87,
              ),
              theme: theme,
            ),
            Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
            _buildListTile(
              icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Темная тема',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeColor: theme.brightness == Brightness.dark
                    ? const Color(0xFF9FBAF1)
                    : Colors.black87,
              ),
              theme: theme,
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
    required ThemeData theme,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: theme.dividerColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _showLogoutDialog(context, theme),
          child: Text(
            'Выйти из аккаунта',
            style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('Подтверждение', style: theme.textTheme.titleLarge),
        content: Text('Вы действительно хотите выйти?', style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: theme.textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Логика выхода
            },
            child: Text('Выйти', style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            )),
          ),
        ],
      ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderHistoryProvider>(context);
    final orders = orderProvider.orders;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
        elevation: 0,
      ),
      body: orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: theme.dividerColor),
            const SizedBox(height: 16),
            Text(
              'Нет истории заказов',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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
            elevation: 0,
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.dividerColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Заказ #${order.id}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Дата: ${order.date.day}.${order.date.month}.${order.date.year}'),
                  const SizedBox(height: 8),
                  Text('Статус: ${order.status}'),
                  const SizedBox(height: 8),
                  Text('Адрес: ${order.address}'),
                  const SizedBox(height: 8),
                  Text('Карта: **** **** **** ${order.cardNumber.length >= 4 ? order.cardNumber.substring(order.cardNumber.length - 4) : order.cardNumber}'),
                  const SizedBox(height: 8),
                  Text('Сумма: ${order.totalPrice.toStringAsFixed(0)} ₽'),
                  const SizedBox(height: 12),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 8),
                  Text('Товары:', style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('• ${item.title} x${item.quantity}'),
                  )).toList(),
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
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    if (order.address.isNotEmpty && order.cardNumber.isNotEmpty) {
      _orders.insert(0, order);
      notifyListeners();
    }
  }

  void loadOrders() async {
    // Загрузка тестовых данных
    _orders.addAll([
      Order(
        id: '1001',
        date: DateTime.parse('2023-05-15'),
        status: 'Доставлен',
        items: [
          OrderItem(title: 'Товар 1', quantity: 1),
          OrderItem(title: 'Товар 2', quantity: 2),
        ],
        totalPrice: 5499.0,
        cardNumber: '1234567812345678',
        address: 'Москва, ул. Пушкина, д. 10',
      ),
      Order(
        id: '1002',
        date: DateTime.parse('2023-06-20'),
        status: 'Доставлен',
        items: [
          OrderItem(title: 'Товар 3', quantity: 3),
        ],
        totalPrice: 3299.0,
        cardNumber: '8765432187654321',
        address: 'Санкт-Петербург, Невский пр., д. 25',
      ),
    ]);
    notifyListeners();
  }
}

class CheckoutModal extends StatefulWidget {
  final List<CartItem> items;
  final double totalPrice;

  const CheckoutModal({
    super.key,
    required this.items,
    required this.totalPrice,
  });

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  final _addressController = TextEditingController();
  final _cardController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.cardColor,
      title: Text('Введите данные', style: theme.textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Адрес доставки',
              labelStyle: theme.textTheme.bodyMedium,
            ),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cardController,
            decoration: InputDecoration(
              labelText: 'Номер карты',
              labelStyle: theme.textTheme.bodyMedium,
            ),
            style: theme.textTheme.bodyMedium,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена', style: theme.textTheme.bodyMedium),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
          ),
          onPressed: () {
            if (_addressController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Введите адрес доставки!', style: theme.textTheme.bodyMedium),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
              return;
            }

            final cardNumber = _cardController.text.trim();
            if (cardNumber.isEmpty || cardNumber.length < 4) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Номер карты должен содержать минимум 4 цифры!', style: theme.textTheme.bodyMedium),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
              return;
            }

            final orderProvider = Provider.of<OrderHistoryProvider>(context, listen: false);

            final newOrder = Order(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.now(),
              status: 'В обработке',
              items: widget.items.map((cartItem) => OrderItem(
                title: cartItem.title,
                quantity: cartItem.quantity,
              )).toList(),
              totalPrice: widget.totalPrice,
              cardNumber: cardNumber,
              address: _addressController.text.trim(),
            );

            orderProvider.addOrder(newOrder);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Заказ успешно оформлен!', style: theme.textTheme.bodyMedium),
                backgroundColor: theme.primaryColor,
              ),
            );
          },
          child: Text('Подтвердить', style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          )),
        )
      ],
    );
  }
}