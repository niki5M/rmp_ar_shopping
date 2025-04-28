import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testik2/features/auth/presentation/pages/login_page.dart';
import 'package:testik2/init_dependencies.dart';
import 'package:testik2/core/theme/theme.dart';
import 'package:testik2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:testik2/screens/home_screen.dart';
import 'features/cart/cart_provider.dart';
import 'features/cart/cart_screen.dart';
import 'features/cart/product_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: AppTheme.darkThemeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}












class Building extends StatelessWidget {
  const Building({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0D1313),
        extendBodyBehindAppBar: true, 
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: home(context),
      ),
    );
  }
}

Widget home(BuildContext context) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Group1.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30), //MediaQuery.of(context).size.width
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(image: AssetImage('assets/images/PhotoArt.png')),
                SizedBox(width: 15,),
                IconButton(onPressed: (){}, icon: Icon(Icons.person_pin, size: 40,), color: Colors.white, )
              ],
            ),
            SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.ac_unit),
                        Text('Редактировать'),
                      ],
                    ) ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(100, 50),
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.access_time_filled),
                        Text('Камера'),
                      ],
                    ) ),
              ],
            ),

          ],
        ),
      ),
    ],
  );
}