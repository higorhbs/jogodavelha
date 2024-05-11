import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  bool OTurn = true; // the first Jogador is O
  bool withAI = false; // define is Jogador 2 AI
  bool gameOver = false; // individual game is over
  int JogadorOneScore = 0;
  int JogadorTwoScore = 0;
  int filledBoxes = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(
          () => withAI = ModalRoute.of(context)?.settings.arguments != null);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Jogador 1 (O)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          '$JogadorOneScore - $JogadorTwoScore',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      withAI ? 'IA (X)' : 'Jogador 2 (X)',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _gridTapped(index),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700)),
                      child: Center(
                        child: displayXO[index] == ''
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  displayXO[index] == 'O'
                                      ? 'assets/icons/oh.png'
                                      : 'assets/icons/ex.png',
                                ),
                              ),
                      ),
                    ),
                  );
                },
                itemCount: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gridTapped(int index) {
    if (displayXO[index] == '') {
      setState(() {
        if (OTurn) {
          displayXO[index] = 'O';
        } else {
          displayXO[index] = 'X';
        }
        OTurn = !OTurn;
        filledBoxes += 1;
        _checkWinner();
        if (withAI && !OTurn && filledBoxes < 9 && !gameOver) {
          _botMove();
        }
      });
    }
  }

  _botMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == '') {
        emptyCells.add(i);
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = emptyCells[Random().nextInt(emptyCells.length)];
      setState(() {
        displayXO[randomIndex] = 'X';
        filledBoxes += 1;
        _checkWinner();
        OTurn = true;
      });
    }
  }

  _checkWinner() {
    // First Row
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2]) {
      _showWinDialog(displayXO[0]);
      gameOver = true;
      return;
    }
    // Second Row
    if (displayXO[3] != '' &&
        displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5]) {
      _showWinDialog(displayXO[3]);
      gameOver = true;
      return;
    }
    // Third Row
    if (displayXO[6] != '' &&
        displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8]) {
      _showWinDialog(displayXO[6]);
      gameOver = true;
      return;
    }
    // First Column
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6]) {
      _showWinDialog(displayXO[0]);
      gameOver = true;
      return;
    }
    // Second Column
    if (displayXO[1] != '' &&
        displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7]) {
      _showWinDialog(displayXO[1]);
      gameOver = true;
      return;
    }
    // Third Column
    if (displayXO[2] != '' &&
        displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8]) {
      _showWinDialog(displayXO[2]);
      gameOver = true;
      return;
    }
    // Check Diagonal
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8]) {
      _showWinDialog(displayXO[0]);
      gameOver = true;
      return;
    }
    // Check Diagonal
    if (displayXO[6] != '' &&
        displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2]) {
      _showWinDialog(displayXO[6]);
      gameOver = true;
      return;
    }
    if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  _showWinDialog(String winner) {
    if (winner == 'O') {
      JogadorOneScore += 1;
    } else {
      JogadorTwoScore += 1;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('$winner Ganhou!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text('Jogar novamente!'),
            )
          ],
        );
      },
    ).then((value) => _resetGame);
  }

  _showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('DRAW!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text('Play Again!'),
            )
          ],
        );
      },
    ).then((value) => _resetGame);
  }

  _resetGame() {
    setState(() {
      displayXO = ['', '', '', '', '', '', '', '', ''];
      OTurn = true;
      filledBoxes = 0;
      gameOver = false;
    });
  }
}
