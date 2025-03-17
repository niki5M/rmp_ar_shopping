import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../helper/tints.dart';
import '../model/tint.dart';
import '../providers/image_provider.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({super.key});

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  late List<Tint> tints;
  int index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
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
               Uint8List? bytes = await screenshotController.capture();
               imageProvider.changeImage(bytes!);
               if (!mounted) {
                 return;
               }
               Navigator.of(context).pushReplacementNamed('/edit');
            },
            icon: Icon(Icons.check, size: 30, color: Colors.white),
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, AppImageProvider value, Widget? child) {
                if (value.currentImage != null) {
                  return Screenshot(
                       child: Image.memory(value.currentImage!,
                       color: tints[index].color.withOpacity(tints[index].opacity),
                         colorBlendMode: BlendMode.color,
                       ),
                      controller: screenshotController);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Align(
            alignment:  Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min ,
              children: [
                slider(
                  tints[index].opacity, (value){
                  setState(() {
                    tints[index].opacity = value;
                  });
                }),
              ],
            ),
          )

        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 110,
        color: Colors.black87,
        child: SafeArea(
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tints.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    Tint tint = tints[index];
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          this.index = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          backgroundColor: this.index == index
                              ? Colors.white : Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: CircleAvatar(
                              backgroundColor: tint.color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ))
    ),


    );
  }

  Widget slider( value, onChanged){
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 1,
        min: 0,
        onChanged: onChanged
    );
  }
}
