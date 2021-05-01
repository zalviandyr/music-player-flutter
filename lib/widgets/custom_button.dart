import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final List<Color> gradient;

  const CustomButton({
    required this.onPressed,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(2, 0),
          ),
        ],
        shape: BoxShape.circle,
      ),
      height: 45.0,
      child: MaterialButton(
        height: double.infinity,
        shape: CircleBorder(),
        minWidth: 0.0,
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
