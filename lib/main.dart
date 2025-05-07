import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testik2/features/auth/presentation/pages/login_page.dart';
import 'package:testik2/init_dependencies.dart';
import 'package:testik2/core/theme/theme.dart';
import 'package:testik2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:testik2/screens/ar_try_on_screen.dart';
import 'package:testik2/features/home/screens/home_screen.dart';
import 'core/theme/theme_provider.dart';
import 'features/cart/cart_provider.dart';
import 'features/cart/cart_screen.dart';
import 'features/cart/product_detail_screen.dart';
import 'features/favorites/favorites_provider.dart';
import 'features/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()..loadOrders()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LUMIO',
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/cart': (context) => const CartScreen(),
        '/ar_try_on': (context) => const PseudoARViewScreen(),
      },
    );
  }
}
