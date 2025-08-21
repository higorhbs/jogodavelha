import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// Botão customizado com gradiente, sombra, borda arredondada, efeito de escala e fonte Montserrat
class _AnimatedGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedGradientButton({required this.onPressed});

  @override
  State<_AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<_AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFe52d27), Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Text(
            'Jogar novamente',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  bool OTurn = true; // the first Jogador is O
  bool withAI = false; // define is Jogador 2 AI
  bool gameOver = false; // individual game is over
  int JogadorOneScore = 0;
  int JogadorTwoScore = 0;
  int filledBoxes = 0;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => withAI = ModalRoute.of(context)?.settings.arguments != null);
    });
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe0eafc),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 370;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/icons/oh.png', width: isSmall ? 24 : 32),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Jogador 1',
                                    style: TextStyle(
                                      fontSize: isSmall ? 13 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4f8cff),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'O',
                              style: TextStyle(
                                fontSize: isSmall ? 15 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(
                              horizontal: isSmall ? 10 : 24, vertical: isSmall ? 8 : 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '$JogadorOneScore  :  $JogadorTwoScore',
                            style: TextStyle(
                              fontSize: isSmall ? 18 : 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4f8cff),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Jogador 2',
                                    style: TextStyle(
                                      fontSize: isSmall ? 13 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFff6b6b),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Image.asset('assets/icons/ex.png', width: isSmall ? 24 : 32),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              withAI ? 'IA' : 'X',
                              style: TextStyle(
                                fontSize: isSmall ? 15 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _gridTapped(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: displayXO[index] == ''
                                ? Colors.transparent
                                : (displayXO[index] == 'O'
                                    ? const Color(0xFF4f8cff)
                                    : const Color(0xFFff6b6b)),
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: displayXO[index] == ''
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                    displayXO[index] == 'O'
                                        ? 'assets/icons/oh.png'
                                        : 'assets/icons/ex.png',
                                    width: 48,
                                    height: 48,
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reiniciar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4f8cff),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  elevation: 0,
                ),
              ),
            ),
              ],
            ),
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.12,
                numberOfParticles: 30,
                maxBlastForce: 30,
                minBlastForce: 10,
                gravity: 0.25,
                colors: const [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                ],
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
  // Linhas
  if (displayXO[0] != '' &&
      displayXO[0] == displayXO[1] &&
      displayXO[0] == displayXO[2]) {
    _showWinDialog(displayXO[0]);
    gameOver = true;
    return;
  }
  if (displayXO[3] != '' &&
      displayXO[3] == displayXO[4] &&
      displayXO[3] == displayXO[5]) {
    _showWinDialog(displayXO[3]);
    gameOver = true;
    return;
  }
  if (displayXO[6] != '' &&
      displayXO[6] == displayXO[7] &&
      displayXO[6] == displayXO[8]) {
    _showWinDialog(displayXO[6]);
    gameOver = true;
    return;
  }

  // Colunas
  if (displayXO[0] != '' &&
      displayXO[0] == displayXO[3] &&
      displayXO[0] == displayXO[6]) {
    _showWinDialog(displayXO[0]);
    gameOver = true;
    return;
  }
  if (displayXO[1] != '' &&
      displayXO[1] == displayXO[4] &&
      displayXO[1] == displayXO[7]) {
    _showWinDialog(displayXO[1]);
    gameOver = true;
    return;
  }
  if (displayXO[2] != '' &&
      displayXO[2] == displayXO[5] &&
      displayXO[2] == displayXO[8]) {
    _showWinDialog(displayXO[2]);
    gameOver = true;
    return;
  }

  // Diagonais
  if (displayXO[0] != '' &&
      displayXO[0] == displayXO[4] &&
      displayXO[0] == displayXO[8]) {
    _showWinDialog(displayXO[0]);
    gameOver = true;
    return;
  }
  if (displayXO[6] != '' &&
      displayXO[6] == displayXO[4] &&
      displayXO[6] == displayXO[2]) {
    _showWinDialog(displayXO[6]);
    gameOver = true;
    return;
  }

  // Empate
  if (filledBoxes == 9) {
    _showDrawDialog();
  }
}




  _showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empate!'),
          actions: [
            _AnimatedGradientButton(onPressed: () {
              Navigator.pop(context);
              _resetGame();
            }),
          ],
        );
      },
    ).then((value) => _resetGame);
  }

  void _showWinDialog(String winner) {
    if (winner == 'O') {
      JogadorOneScore += 1;
    } else if (winner == 'X') {
      JogadorTwoScore += 1;
    }
    _confettiController.play();
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        '🏆 Vitória!',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Jogador ${winner == 'O' ? '1' : '2'} venceu!',
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        _AnimatedGradientButton(
          onPressed: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
      ],
    );
  },
).then((value) => _resetGame());

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
