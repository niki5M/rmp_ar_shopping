import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testik2/providers/image_provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/');
        },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30,)),
        title: Text('Редактор', style: TextStyle(fontSize: 30, color: Colors.white),),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.menu, size: 30, color: Colors.white,))],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, AppImageProvider value, Widget? child) {
            if(value.currentImage != null){
              return Image.memory(
                  value.currentImage!,
                  fit: BoxFit.fitWidth,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 110,
          color: Colors.black87,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(

              children: [
                // Update the navigation in the bottom buttons:
                _bottomButItem(
                    'assets/icons/filtr_button.png',
                    'Обрезать',
                    onPress: () {
                      Navigator.pushNamed(context, '/crop');
                    }
                ),
                _bottomButItem(
                    'assets/icons/filtr_button.png',
                    'Фильтр',
                    onPress: () {
                      Navigator.pushNamed(context, '/filter');
                    }
                ),

                _bottomButItem(
                    'assets/icons/adjust_button.png',
                    'Обработка',
                    onPress: (){
                      Navigator.of(context).pushReplacementNamed('/adjust');
                    }
                ),
                _bottomButItem(
                    'assets/icons/fit_button.png',
                    'Fit',
                    onPress: (){
                      Navigator.of(context).pushReplacementNamed('/fit');
                    }
                ),
                _bottomButItem(
                    'assets/icons/filtr_button.png',
                    'Tint',
                    onPress: (){
                      Navigator.of(context).pushReplacementNamed('/tint');
                    }
                    ),
                _bottomButItem(
                    'assets/icons/fit_button.png',
                    'Blur',
                    onPress: (){
                      Navigator.of(context).pushReplacementNamed('/blur');
                    }
                ),
                _bottomButItem(
                    'assets/icons/fit_button.png',
                    'Text',
                    onPress: (){
                      Navigator.of(context).pushReplacementNamed('/text');
                    }
                ),

              ],
            ),
          ),
        ),
    ),
    );
  }

  Widget _bottomButItem(String imagePath, String title, {required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

  }
}
