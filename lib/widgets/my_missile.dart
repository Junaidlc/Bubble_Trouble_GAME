import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  final missileX;
  final height;
  const MyMissile({super.key, this.missileX, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 50,
        height: height,
        child: Image.asset("assets/icons/missile_fire_icon.png"),
      ),
    );
  }
}