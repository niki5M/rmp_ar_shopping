import 'dart:io';
import 'dart:typed_data' show ByteData, Uint8List;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/image_provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {

  // late CropController controller;


  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );


  late AppImageProvider imageProvider;

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.of(context).pushReplacementNamed('/edit');}, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30,)),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                print('Начинаем обрезку изображения...');
                ui.Image bitmap = await controller.croppedBitmap();
                ByteData? data = await bitmap.toByteData(format: ui.ImageByteFormat.png);

                if (data == null) {
                  print('Ошибка: данные изображения null!');
                  return;
                }

                Uint8List bytes = data.buffer.asUint8List();
                imageProvider.changeImage(bytes);
                if (!mounted) {
                  return;
                }

                Navigator.of(context).pushReplacementNamed('/edit');
                print('Экран закрыт успешно.');
              } catch (e) {
                print('Ошибка при сохранении изображения: $e');
              }
            },
            icon: Icon(Icons.check, size: 30, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, AppImageProvider value, Widget? child) {
            print('Обновленный размер изображения: ${value.currentImage?.length ?? 'Нет изображения'}');
            if (value.currentImage != null) {
              return CropImage(
                controller: controller,
                image: Image.memory(value.currentImage!),
                gridColor: Colors.white,
                gridInnerColor: Colors.white,
                gridCornerColor: Colors.white,
                gridCornerSize: 50,
                showCorners: true,
                gridThinWidth: 3,
                gridThickWidth: 6,
                scrimColor: Colors.grey.withOpacity(0.5),
                alwaysShowThirdLines: true,
                onCrop: (rect) => print(rect),
                minimumImageSize: 50,
                maximumImageSize: 2000,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _bottomButItem(child: Icon(Icons.rotate_90_degrees_ccw_outlined, color: Colors.white,size: 35,), onPress: (){ controller.rotateLeft();}),
              _bottomButItem(child: Icon(Icons.rotate_90_degrees_cw_outlined, color: Colors.white,size: 35,), onPress: (){ controller.rotateRight();}),
              
              Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  color: Colors.white70,
                  height: 40,
                  width: 1,

                ),
              ),
              _bottomButItem(child: Text('1:1',
                style: TextStyle(
                  color: Colors.white,
                ),
              ), onPress: (){
                controller.aspectRatio = 1;
                controller.crop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              }),
              _bottomButItem(child: Text('2:1',
                style: TextStyle(
                  color: Colors.white,
                ),
              ), onPress: (){
                controller.aspectRatio = 2;
                controller.crop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              }),
              _bottomButItem(child: Text('1:2',
                style: TextStyle(
                  color: Colors.white,
                ),
              ), onPress: (){
                controller.aspectRatio = 1/2;
                controller.crop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              }),
              _bottomButItem(child: Text('4:3',
                style: TextStyle(
                  color: Colors.white,
                ),
              ), onPress: (){
                controller.aspectRatio = 4/3;
                controller.crop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              }),
              _bottomButItem(child: Text('16:9 ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ), onPress: (){
                controller.aspectRatio = 16/9;
                controller.crop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomButItem({required child,required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: child,
        ),),
    );
  }
}
