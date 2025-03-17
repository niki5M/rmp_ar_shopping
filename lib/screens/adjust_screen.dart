import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/image_provider.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {

  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double sepia = 0;
  double hue = 0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;
  bool showSepia = false ;

  late ColorFilterGenerator adj;


  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  showSlider({b, c, s, h, se}){
    setState(() {
      showBrightness = b != null ? true : false;
      showContrast = c != null ? true : false;
      showSaturation = s != null ? true : false;
      showHue = h != null ? true : false;
      showSepia = se != null ? true : false;
    });

  }


  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  adjust({b, c, s, h, se}){
    adj = ColorFilterGenerator(
        name: 'Adjust',
        filters: [
          ColorFilterAddons.brightness(b ?? brightness),
          ColorFilterAddons.contrast(c ?? contrast),
          ColorFilterAddons.saturation(s ?? saturation),
          ColorFilterAddons.hue(h ?? hue),
          ColorFilterAddons.sepia(se ?? sepia),

    ]);
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
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(adj.matrix),
                        child: Image.memory(value.currentImage!,fit: BoxFit.contain),),
                      controller: screenshotController);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Align(
            alignment:  Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible:showBrightness,
                        child: slider(brightness, (value){
                          setState(() {
                            brightness = value;
                            adjust(b: brightness);
                          });
                        }),
                      ),
                      Visibility(
                        visible:showContrast,
                        child: slider(contrast, (value){
                          setState(() {
                            contrast = value;
                            adjust(c: contrast);
                          });
                        }),
                      ),
                      Visibility(
                        visible:showSaturation,
                        child: slider(saturation, (value){
                          setState(() {
                            saturation = value;
                            adjust(s: saturation);
                          });
                        }),
                      ),
                      Visibility(
                        visible:showHue,
                        child: slider(hue, (value){
                          setState(() {
                            hue = value;
                            adjust(h: hue);
                          });
                        }),
                      ),
                      Visibility(
                        visible:showSepia,
                        child: slider(sepia, (value){
                          setState(() {
                            sepia = value;
                            adjust(se: sepia);
                          });
                        }),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: Text('Reset',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
                  onPressed: (){
                    setState(() {
                      brightness = 0;
                      contrast = 0;
                      saturation = 0;
                      hue = 0;
                      sepia = 0;
                      adjust(
                        b: brightness,
                        c: contrast,
                        s: saturation,
                        h: hue,
                        se: sepia,
                      );
                    });
                  },
                ),
              ],
            ),
          )

        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 110,
        color: Colors.black87,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(

            children: [
              _bottomButItem(
                  'assets/icons/brightness_button.png',
                  'Brightness',
                  onPress: (){
                    showSlider(b: true);
                  }
              ),
              _bottomButItem(
                  'assets/icons/contrast_button.png',
                  'Contrast',
                  onPress: (){
                    showSlider(c: true);
                  }
              ),
              _bottomButItem(
                  'assets/icons/saturation_button.png',
                  'Saturation',
                  onPress: (){
                    showSlider(s: true);
                  }
              ),
              _bottomButItem(
                  'assets/icons/hue_button.png',
                  'Hue',
                  onPress: (){
                    showSlider(h: true);
                  }
              ),
              _bottomButItem(
                  'assets/icons/sepia_button.png',
                  'Sepia',
                  onPress: (){
                    showSlider(se: true);
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _bottomButItem(String imagePath, String title, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
            SizedBox(height: 5,),
            Text(title, style: TextStyle(color: Colors.white),),
          ],
        ),),
    );
  }

  Widget slider( value, onChanged){
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 1,
        min: -0.9,
        onChanged: onChanged
    );
  }

}
