import 'package:flutter/material.dart';

class PickYourSide extends StatefulWidget {
  const PickYourSide({super.key});

  @override
  State<PickYourSide> createState() => _PickYourSideState();
}

class _PickYourSideState extends State<PickYourSide> {
  String selectedSide = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Pick Your Side',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _setupSide('X'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/ex.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        const SizedBox(height: 20),
                        Transform.scale(
                          scale: 1.5,
                          child: Radio(
                            value: 'X',
                            groupValue: selectedSide,
                            onChanged: _setupSide,
                            activeColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _setupSide('O'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/oh.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        const SizedBox(height: 20),
                        Transform.scale(
                          scale: 1.5,
                          child: Radio(
                            value: 'O',
                            groupValue: selectedSide,
                            onChanged: _setupSide,
                            activeColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _setupSide(String? value) {
    setState(() => selectedSide = value ?? '');
  }
}
