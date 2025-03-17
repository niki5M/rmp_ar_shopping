import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: const Text('Изображение'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewScreen(imagePath: _image!.path),
        ),
      );
    }
  }

  Future<void> _captureImage() async {
    final capturedFile = await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      setState(() {
        _image = capturedFile;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewScreen(imagePath: _image!.path),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D1313),
      body: Stack(
        children: [
          _buildHeaderWithButtons(),
          Column(
            children: [
              const SizedBox(height: 450),
              _buildFeatureIcons(),
              Expanded(child: _buildProjectsList()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithButtons() {
    return Stack(
      children: [
        _buildHeaderImage(),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: _buildAppBar(),
        ),
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: _image == null
            ? const DecorationImage(
          image: AssetImage('assets/images/Group1.png'),
          fit: BoxFit.cover,
        )
            : DecorationImage(
          image: FileImage(File(_image!.path)), // Отображаем выбранное изображение
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PhotoArt',
            style: GoogleFonts.modak(
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/profile_button.png',
              width: 30,
              height: 30,
            ),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton('assets/icons/edit_button.png', 'Редактировать', _pickImage),
        _buildActionButton('assets/icons/camera_button.png', 'Камера', _captureImage),
      ],
    );
  }

  Widget _buildActionButton(String imagePath, String label, [VoidCallback? onPressed]) {
    return SizedBox(
      width: 165,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFeatureIcon('assets/icons/kist_button.png', 'Кисть'),
          _buildFeatureIcon('assets/icons/color_button.png', 'Цвет'),
          _buildFeatureIcon('assets/icons/filtr_button.png', 'Фильтр'),
          _buildFeatureIcon('assets/icons/kollag_button.png', 'Коллаж'),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(String imagePath, String label) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print('Нажата кнопка $label');
          },
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildProjectsList() {
    final projects = [
      {'title': 'Проект5', 'date': '23.02.2025', 'size': '31MB'},
      {'title': 'Проект4', 'date': '01.02.2025', 'size': '12MB'},
      {'title': 'Проект4', 'date': '11.01.2025', 'size': '28MB'},
      {'title': 'Проект3', 'date': '03.01.2025', 'size': '---'},
      {'title': 'Проект2', 'date': '03.01.2025', 'size': '---'},
    ];

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Text(
            project['title']!,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${project['date']} \n${project['size']}',
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.more_vert, color: Colors.white),
          onTap: () {},
        );
      },
    );
  }
}