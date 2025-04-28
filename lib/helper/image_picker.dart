import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AppImagePicker {
  final ImageSource source;

  AppImagePicker({required this.source});

  Future<void> pick({required Function(File?) onPick}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      onPick(image != null ? File(image.path) : null);
    } catch (e) {
      onPick(null);
    }
  }
}