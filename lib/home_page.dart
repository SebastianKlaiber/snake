import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/blank_pixel.dart';
import 'package:snake/food_pixel.dart';
import 'package:snake/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  bool gameHasStarted = false;

  int currentScore = 0;

  /// snake position
  List<int> snakePos = [0, 1, 2];

  var currentDirection = Direction.right;

  /// fodd position
  int foodPosition = 55;

  void startGame() {
    gameHasStarted = true;

    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(() {
          moveSnake();
          if (gameOver()) {
            timer.cancel();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your score is: $currentScore'),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter name',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        submitScore();
                        newGame();
                      },
                      color: Colors.pink,
                      child: const Text('Submit'),
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }

  void submitScore() {}

  void newGame() {
    setState(() {
      snakePos = [
        0,
        1,
        2,
      ];

      foodPosition == 55;
      currentDirection = Direction.right;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case Direction.up:
        if (snakePos.last < rowSize) {
          snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
        } else {
          snakePos.add(snakePos.last - rowSize);
        }

        break;
      case Direction.down:
        if (snakePos.last + rowSize > totalNumberOfSquares) {
          snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
        } else {
          snakePos.add(snakePos.last + rowSize);
        }

        break;
      case Direction.left:
        if (snakePos.last % rowSize == 0) {
          snakePos.add(snakePos.last - 1 + rowSize);
        } else {
          snakePos.add(snakePos.last - 1);
        }

        break;
      case Direction.right:
        if (snakePos.last % rowSize == 9) {
          snakePos.add(snakePos.last + 1 - rowSize);
        } else {
          snakePos.add(snakePos.last + 1);
        }

        break;
    }

    if (snakePos.last == foodPosition) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    final bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          /// high scores
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Current Score'),
                    Text(
                      currentScore.toString(),
                      style: const TextStyle(fontSize: 36),
                    ),
                  ],
                ),
                const Text('highscores...'),
              ],
            ),
          ),

          /// game grid
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && currentDirection != Direction.up) {
                  currentDirection = Direction.down;
                } else if (details.delta.dy < 0 &&
                    currentDirection != Direction.down) {
                  currentDirection = Direction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != Direction.left) {
                  currentDirection = Direction.right;
                } else if (details.delta.dx < 0 &&
                    currentDirection != Direction.right) {
                  currentDirection = Direction.left;
                }
              },
              child: GridView.builder(
                itemCount: totalNumberOfSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize,
                ),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPosition == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),

          /// play button
          Expanded(
            child: Center(
              child: MaterialButton(
                onPressed: gameHasStarted ? null : startGame,
                color: Colors.pink,
                child: const Text('PLAY'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
