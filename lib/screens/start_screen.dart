import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../helper/image_picker.dart';
import '../providers/image_provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Group1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/PhotoArt.png',
                height: 100,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        icon: Icons.edit,
                        label: 'Редактировать',
                        onTap: () {
                          AppImagePicker(source: ImageSource.gallery).pick(
                            onPick: (File? image) {
                              imageProvider.changeImageFile(image!);
                              Navigator.of(context).pushReplacementNamed('/edit');
                            },
                          );
                        },
                      ),
                      _buildButton(
                        icon: Icons.camera_alt,
                        label: 'Камера',
                        onTap: () {
                          AppImagePicker(source: ImageSource.camera).pick(
                            onPick: (File? image) {
                              imageProvider.changeImageFile(image!);
                              Navigator.of(context).pushReplacementNamed('/edit');
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
