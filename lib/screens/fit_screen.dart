import 'dart:typed_data';
import 'dart:ui'; // Импорт для размытия
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Для выбора цвета
import '../providers/image_provider.dart';

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  int x = 1, y = 1;

  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showTexture = false;

  double blurValue = 0.0; // Уровень размытия
  Color backgroundColor = Colors.black; // Цвет фона
  Uint8List? backgroundImage; // Фоновое изображение
  String? texturePath; // Путь к текстуре

  // Выбор изображения из галереи
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async{
        backgroundImage = await pickedFile.readAsBytes();
      });
    }
  }

  // Открытие цветового выбора
  void _pickBackgroundColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Background Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: backgroundColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // Выбор текстуры для фона
  void _pickTexture() {
    // Логика для выбора текстуры (например, выбор изображения или паттерна)
    // Здесь можно использовать тот же image_picker или другие способы
  }

  void showActiveWidget({bool r = false, bool b = false, bool c = false, bool t = false}) {
    setState(() {
      showRatio = r;
      showBlur = b;
      showColor = c;
      showTexture = t;
    });
  }

  Future<void> _saveImage(AppImageProvider provider) async {
    Uint8List? bytes = await screenshotController.capture();
    if (bytes != null) {
      provider.changeImage(bytes);
      if (mounted) Navigator.of(context).pushReplacementNamed('/edit');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<AppImageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/edit'),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () => _saveImage(imageProvider),
            icon: const Icon(Icons.check, size: 30, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, child) {
            if (value.currentImage == null) return const CircularProgressIndicator();

            return AspectRatio(
              aspectRatio: x / y,
              child: Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    Container(color: backgroundColor), // Фоновый цвет
                    if (backgroundImage != null)
                      Positioned.fill(
                        child: Image.memory(backgroundImage!, fit: BoxFit.cover),
                      ),
                    if (showBlur) _blurWidget(), // Размытие
                    Center(child: Image.memory(value.currentImage!)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      height: showBlur ? 250 : 150, // Увеличиваем высоту при размытии
      color: Colors.black87,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showBlur) _blurSlider(), // Ползунок размытия
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showRatio) ...[
                      _ratioButton('1:1', () => setState(() { x = 1; y = 1; })),
                      _ratioButton('1:2', () => setState(() { x = 1; y = 2; })),
                      _ratioButton('2:1', () => setState(() { x = 2; y = 1; })),
                      _ratioButton('3:4', () => setState(() { x = 3; y = 4; })),
                      _ratioButton('4:3', () => setState(() { x = 4; y = 3; })),
                      _ratioButton('16:9', () => setState(() { x = 16; y = 9; })),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomBarItem(Icons.aspect_ratio_outlined, 'Ratio', () => showActiveWidget(r: true)),
                _bottomBarItem(Icons.blur_linear_outlined, 'Blur', () => showActiveWidget(b: true)),
                _bottomBarItem(Icons.color_lens_outlined, 'Color', () {
                  _pickBackgroundColor(); // Вызовем диалог выбора цвета
                  showActiveWidget(c: true);
                }),
                _bottomBarItem(Icons.texture_outlined, 'Texture', () => showActiveWidget(t: true)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurWidget() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _blurSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Blur Level",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Slider(
            value: blurValue,
            min: 0.0,
            max: 20.0,
            divisions: 20,
            label: blurValue.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                blurValue = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _ratioButton(String text, VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onPress,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}