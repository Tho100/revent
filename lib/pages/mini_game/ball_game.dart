import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class _Specification {

  static const paddleWidth = 125.0;
  static const paddleHeight = 25.0; 

}

class _Ball {

  double x, y, radius, dx, dy;

  _Ball({
    required this.x, 
    required this.y, 
    required this.radius, 
    required this.dx, 
    required this.dy
  });

  void updatePosition() {
    x += dx;
    y += dy;
  }
  
}

class _PongPainter extends CustomPainter {
  
  final double paddlePosition;
  final _Ball ball;

  _PongPainter({required this.paddlePosition, required this.ball});

  @override
  void paint(Canvas canvas, Size size) {

    final paddleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        paddlePosition,
        size.height - _Specification.paddleHeight, 
        _Specification.paddleWidth,
        _Specification.paddleHeight,
      ),
      const Radius.circular(12),
    );

    canvas.drawRRect(
      paddleRect,
      Paint()
        ..color = ThemeColor.contentSecondary
        ..style = PaintingStyle.fill);

    canvas.drawCircle(
        Offset(ball.x, ball.y),
        ball.radius*1.2,
        Paint()
          ..color = ThemeColor.contentThird
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class PongGame extends StatefulWidget {

  const PongGame({Key? key}) : super(key: key);

  @override
  State<PongGame> createState() => _PongGameState();

}

class _PongGameState extends State<PongGame> {
  
  late double paddlePosition;
  late _Ball ball;

  final scoreNotifier = ValueNotifier<int>(0);
  final highScoreNotifier = ValueNotifier<int>(0);

  int highScore = 0;

  List<int> highScoresList = [];

  Widget _buildPaddle() {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        setState(() {

          final screenWidth = MediaQuery.of(context).size.width;
          
          paddlePosition += details.delta.dx;

          if (paddlePosition < 0) {
            paddlePosition *= 0.5;
          } else if (paddlePosition + _Specification.paddleWidth > screenWidth) {
            final overflow = paddlePosition + _Specification.paddleWidth - screenWidth;
            paddlePosition -= overflow * 0.5;
          }

        });
      },
      child: CustomPaint(
        painter: _PongPainter(
          paddlePosition: paddlePosition,
          ball: ball,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-90,
        ),
      ),
    );
  }

  Widget _buildHighScore() {
    return ValueListenableBuilder(
      valueListenable: highScoreNotifier,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Text("HIGH SCORE: ${value.toString()}", 
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.bold
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentScore() {
    return ValueListenableBuilder(
      valueListenable: scoreNotifier,
      builder: (context, value, child) {
        return Center(
          child: Text(value.toString(), 
            style: GoogleFonts.poppins(
              fontSize: 135,
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.bold
            )
          ),
        );
      },
    );
  }

  void _checkCollisions() {

    final paddleTop = MediaQuery.of(context).size.height - 112;

    if (ball.y + ball.radius >= paddleTop 
      && ball.x >= paddlePosition 
      &&  ball.x <= paddlePosition + 155 
      &&  ball.y - ball.radius <= paddleTop + 10) {

      scoreNotifier.value++;
      highScore = scoreNotifier.value;
      ball.dy = -ball.dy;

    } else if (ball.y + ball.radius >= MediaQuery.of(context).size.height - 90) {

      highScoresList.add(highScore);
      highScoreNotifier.value = highScoresList.reduce((score, next) => score > next? score: next);
      _resetBall();
      
    }

    if (ball.x - ball.radius <= 0 || ball.x + ball.radius >= MediaQuery.of(context).size.width) {
      ball.dx = -ball.dx;
    }

    if (ball.y - ball.radius <= 0) {
      ball.dy = -ball.dy;
    }

  }

  void _resetBall() {

    ball.x = MediaQuery.of(context).size.width / 2;
    ball.y = MediaQuery.of(context).size.height / 2;

    ball.dx = 3;
    ball.dy = 3; 
    
    highScore = scoreNotifier.value;
    scoreNotifier.value = 0;

  }

  void _startGameLoop() {
    Timer.periodic(const Duration(milliseconds: 6), (timer) {
      setState(() {
        ball.updatePosition();
        _checkCollisions();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    paddlePosition = 165.0;
    ball = _Ball(x: 150, y: 100, radius: 10, dx: 3, dy: 3);
    _startGameLoop();
  }

  @override
  void dispose() {
    highScoreNotifier.dispose();
    scoreNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: ''
      ).buildAppBar(),
      body: Center(
        child: Stack(
          children: [
            
            _buildHighScore(),
            _buildCurrentScore(),
            _buildPaddle()

          ],
        ),
      ),
    );
  }

}