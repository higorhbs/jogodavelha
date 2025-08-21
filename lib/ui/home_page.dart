import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/ui/game_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late AnimationController _cardController;
  late Animation<double> _iconAnimation;
  late Animation<Color?> _titleColorAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<Color?> _cardTitleColorAnim;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _iconAnimation = CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack);
    _titleColorAnimation = ColorTween(
      begin: Colors.red.shade200,
      end: Colors.blue.shade700,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeInOut));
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _cardFadeAnimation = CurvedAnimation(parent: _cardController, curve: Curves.easeIn);
    _cardSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack));
    _cardTitleColorAnim = ColorTween(
      begin: Colors.blue.shade700,
      end: Colors.red.shade200,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeInOut));
    _iconController.forward();
    _titleController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 600), () => _cardController.forward());
  }

  @override
  void dispose() {
    _iconController.dispose();
    _titleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _buttonController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  final opacity = _iconAnimation.value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, (1 - opacity) * 40),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/ex.png',
                      width: size.width * 0.22,
                    ),
                    const SizedBox(width: 24),
                    Image.asset(
                      'assets/icons/oh.png',
                      width: size.width * 0.22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _titleColorAnimation,
                builder: (context, child) {
                  return Text(
                    'Jogo da Velha',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: _titleColorAnimation.value,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  final opacity = _iconAnimation.value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: const Text(
                  'Três em linha para vencer!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              SlideTransition(
                position: _cardSlideAnimation,
                child: AnimatedBuilder(
                  animation: _cardFadeAnimation,
                  builder: (context, child) {
                    final opacity = _cardFadeAnimation.value.clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.93),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white10, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _cardTitleColorAnim,
                          builder: (context, child) {
                            return Text(
                              'Escolha o modo de jogo',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _cardTitleColorAnim.value,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTapDown: _onTapDown,
                          onTapUp: _onTapUp,
                          onTapCancel: () => _buttonController.reverse(),
                          child: AnimatedBuilder(
                            animation: _buttonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonScaleAnimation.value,
                                child: child,
                              );
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GameScreen(),
                                      settings: const RouteSettings(arguments: true)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFff5858),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Contra IA',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTapDown: _onTapDown,
                          onTapUp: _onTapUp,
                          onTapCancel: () => _buttonController.reverse(),
                          child: AnimatedBuilder(
                            animation: _buttonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonScaleAnimation.value,
                                child: child,
                              );
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const GameScreen()),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFff5858),
                                  side: const BorderSide(color: Color(0xFFff5858), width: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text('Contra amigo'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
