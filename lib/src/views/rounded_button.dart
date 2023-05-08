import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final void Function()? onPressed;
  final double radius;
  final double? height;
  final double? width;
  final String text;

  const RoundedButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onPressed,
    this.radius = 10.0,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
