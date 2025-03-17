import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/image_provider.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider imageProvider;
  final ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/edit'),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final bytes = await screenshotController.capture();
              if (bytes != null) {
                imageProvider.changeImage(bytes);
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/edit');
              }
            },
            icon: const Icon(Icons.check, size: 30, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (context, value, child) {
                return value.currentImage != null
                    ? Screenshot(
                  controller: screenshotController,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: sigmaX,
                      sigmaY: sigmaY,
                      tileMode: tileMode,
                    ),
                    child: Image.memory(value.currentImage!,fit: BoxFit.contain),
                  ),
                )
                    : const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomControls(),
    );
  }

  Widget buildBottomControls() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ползунки
          buildSlider('Размытие по X', sigmaX, (value) => setState(() => sigmaX = value)),
          buildSlider('Размытие по Y', sigmaY, (value) => setState(() => sigmaY = value)),

          // Кнопки выбора TileMode
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomButtonItem('Decal', tileMode == TileMode.decal, () {
                  setState(() => tileMode = TileMode.decal);
                }),
                _bottomButtonItem('Clamp', tileMode == TileMode.clamp, () {
                  setState(() => tileMode = TileMode.clamp);
                }),
                _bottomButtonItem('Mirror', tileMode == TileMode.mirror, () {
                  setState(() => tileMode = TileMode.mirror);
                }),
                _bottomButtonItem('Repeated', tileMode == TileMode.repeated, () {
                  setState(() => tileMode = TileMode.repeated);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtonItem(String title, bool isSelected, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSlider(String title, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Slider(
          label: value.toStringAsFixed(2),
          value: value,
          max: 10,
          min: 0.1,
          onChanged: onChanged,
        ),
      ],
    );
  }
}