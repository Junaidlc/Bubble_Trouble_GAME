import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  const MyBall({super.key, required this.ballX, required this.ballY});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        width: 30,
        height:30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.brown,
        ),
        child: Image.asset("assets/icons/ball_icon.png"),
      ),
    );
  }
}
