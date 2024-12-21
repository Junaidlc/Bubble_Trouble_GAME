import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? function;
  const MyButton({super.key, required this.icon,this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          width: 50,
          color: Colors.grey.shade300,
          child: Center(
            child: Icon(
              icon,
            ),
          ),
        ),
      ),
    );
  }
}
