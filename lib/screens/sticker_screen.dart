import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({super.key});

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {

  late AppImageProvider imageProvider;
  late LindiController controller = LindiController( borderColor: Colors.white,
    icons: [
      LindiStickerIcon(
          icon: Icons.done,
          alignment: Alignment.topRight,
          onTap: () {
            controller.selectedWidget!.done();
          }),
      LindiStickerIcon(
          icon: Icons.close,
          alignment: Alignment.topLeft,
          onTap: () {
            controller.selectedWidget!.delete();
          }),
      LindiStickerIcon(
          icon: Icons.flip,
          alignment: Alignment.bottomLeft,
          onTap: () {
            controller.selectedWidget!.flip();
          }),
      LindiStickerIcon(
          icon: Icons.crop_free,
          alignment: Alignment.bottomRight,
          type: IconType.resize
      ),
    ],
  );

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    controller.add(
        Text('Hello World', style: TextStyle(color: Colors.white, fontSize: 25),)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/edit');
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Uint8List? bytes = await screenshotController.capture();
              // imageProvider.changeImage(bytes!);
              // if (!mounted) {
              //   return;
              // }
              // Navigator.of(context).pushReplacementNamed('/edit');
            },
            icon: Icon(Icons.check, size: 30, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, AppImageProvider value, Widget? child) {
            if (value.currentImage != null) {
              return LindiStickerWidget(
                controller: controller,
                child: Image.memory(value.currentImage!),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                ),
                Row(
                  children: [
                    _bottomButItem(child: 'assets/stickers/love.png', onPress:(){}),

                  ],
                )
              ],
            ) ),
      ),

    );
  }
  Widget _bottomButItem({required child,required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(child),
          ],
        ),),
    );
  }
}
