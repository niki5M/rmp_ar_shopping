import 'package:flutter/material.dart';
import 'package:testik2/core/theme/colors.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.buttonText, required this.onPressed});
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(395, 55),
        side: BorderSide(
          color: Palete.lightPrimaryColor,
          width: 2,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Palete.lightPrimaryColor,
      ),
    );

  }
}
