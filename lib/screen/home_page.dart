import 'dart:async';

import 'package:dubble_drible_game/widgets/my_ball.dart';
import 'package:dubble_drible_game/widgets/my_button.dart';
import 'package:dubble_drible_game/widgets/my_missile.dart';
import 'package:dubble_drible_game/widgets/my_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  final FocusNode _focusNode = FocusNode();

  // player variables
  static double playerX = 0;
  bool isGameRunning = false;

  // missile variables
  double missileX = playerX;
  double missileHeight = 30;
  bool midShot = false;
  Timer? missileTimer; // To manage missile movement

  // ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  Timer? gameTimer; // To manage main game loop

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    gameTimer?.cancel(); // Cancel timers on dispose
    missileTimer?.cancel();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Game Over!",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
                startGame();
              },
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void startGame() {
    if (isGameRunning) return; // Prevent starting the game if already running

    isGameRunning = true; // Set the flag to true
    double time = 0;
    double height = 0;
    double velocity = 100;

    gameTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      // Upside down parabola
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToPosition(height);
      });

      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      setState(() {
        if (ballDirection == direction.LEFT) {
          ballX -= 0.005;
        } else if (ballDirection == direction.RIGHT) {
          ballX += 0.005;
        }
      });

      if (playerDies()) {
        timer.cancel();
        gameTimer = null;
        isGameRunning = false;
        _showDialog("You lost the game. Try again!");
        debugPrint("Dead");
      }
      time += 0.1;
    });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 >= -1) {
        playerX -= 0.1;
        if (!midShot) {
          missileX = playerX;
        }
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 <= 1) {
        playerX += 0.1;
        if (!midShot) {
          // Ensure missile follows player only if not mid-shot
          missileX = playerX;
        }
      }
    });
  }

  void fireMissile() {
    if (!midShot && isGameRunning) {
      setState(() {
        midShot = true;
        missileX = playerX;
        missileHeight = 10;
      });

      missileTimer = Timer.periodic(Duration(milliseconds: 5), (timer) {
        setState(() {
          missileHeight += 5; // Adjusted for smoother movement
        });

        // Calculate missile's Y position in game coordinates
        double missileY = heightToPosition(missileHeight);

        // Check if missile is out of bounds
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        // Collision detection between missile and ball
        if ((ballY - missileY).abs() < 0.05 &&
            (ballX - missileX).abs() < 0.03) {
          // Collision detected
          timer.cancel();
          gameTimer?.cancel();
          gameTimer = null;
          isGameRunning = false;
          _showDialog("You hit the ball! You win!");
          debugPrint("Ball hit by missile");
        }
      });
    }
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    return 1 - 2 * height / totalHeight;
  }

  bool playerDies() {
    return (ballX - playerX).abs() < 0.05 && ballY > 0.95;
  }

  void resetMissile() {
    setState(() {
      missileX = playerX;
      missileHeight = 10;
      midShot = false;
    });
  }

  void resetGame() {
    setState(() {
      // Reset all game variables to initial state
      playerX = 0;
      missileX = playerX;
      missileHeight = 10;
      midShot = false;
      ballX = 0.5;
      ballY = 1;
      ballDirection = direction.LEFT;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            moveLeft();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            moveRight();
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            fireMissile(); // Optional: Fire missile with spacebar
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: AssetImage("assets/images/space_bg_non.jpg"))),
                child: Center(
                  child: Stack(
                    children: [
                      MyBall(ballX: ballX, ballY: ballY),
                      if (midShot)
                        MyMissile(height: missileHeight, missileX: missileX),
                      MyPlayer(playerX: playerX),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      icon: Icons.play_arrow,
                      function: startGame,
                    ),
                    MyButton(
                      icon: Icons.arrow_back,
                      function: moveLeft,
                    ),
                    MyButton(
                      icon: Icons.fire_hydrant_alt_rounded,
                      function: fireMissile,
                    ),
                    MyButton(
                      icon: Icons.arrow_forward,
                      function: moveRight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
