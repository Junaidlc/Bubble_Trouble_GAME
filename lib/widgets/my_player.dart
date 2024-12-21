import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  const MyPlayer({super.key, this.playerX});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment(playerX, 1),
        child: Container(
          decoration: BoxDecoration(
          ),
          height: 50,
          width: 50,
          child: Image.asset("assets/icons/avatar_icon.png"),
        ),
      ),
    );
  }
}
