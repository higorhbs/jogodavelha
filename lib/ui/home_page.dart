import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/ui/game_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/ex.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Image.asset(
                    'assets/icons/oh.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Escolha o modo de jogo:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                        settings: const RouteSettings(arguments: true)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Contra IA'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Contra amigo'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
