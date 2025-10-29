import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class _Specification {

  static const paddlePosition = 165.0;
  static const paddleWidth = 100.0;
  static const paddleHeight = 25.0; 
  static const paddleYOffset = 40.0;
  static const paddleCollisionHeight = paddleHeight + 90;

  static const ballXPosition = 110.0;
  static const ballYPosition = 100.0;

  static const ballXShootDirection = 5.0;
  static const ballYShootDirection = -5.0;

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
        size.height - _Specification.paddleHeight - _Specification.paddleYOffset, 
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

class _PongGameState extends State<PongGame> with SingleTickerProviderStateMixin {
  
  _Ball ball = _Ball(
    x: _Specification.ballXPosition, 
    y: _Specification.ballYPosition, 
    dx: _Specification.ballXShootDirection, 
    dy: _Specification.ballYShootDirection,
    radius: 10, 
  );

  final scoreNotifier = ValueNotifier<int>(0);
  final highScoreNotifier = ValueNotifier<int>(0);
  final paddlePositionNotifier = ValueNotifier<double>(_Specification.paddlePosition);

  late Ticker tickerTimer;

  int highScore = 0;
  bool hasBounced = false;

  List<int> highScoresList = [];

  Widget _buildPaddle() {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {

        final screenWidth = MediaQuery.of(context).size.width;
        
        paddlePositionNotifier.value += details.delta.dx;

        if (paddlePositionNotifier.value < 0) {
          paddlePositionNotifier.value *= 0.5;
        } else if (paddlePositionNotifier.value + _Specification.paddleWidth > screenWidth) {
          final overflow = paddlePositionNotifier.value + _Specification.paddleWidth - screenWidth;
          paddlePositionNotifier.value -= overflow * 0.5;
        }

      },
      child: ValueListenableBuilder(
        valueListenable: paddlePositionNotifier,
        builder: (_, paddlePosition, __) {
          return CustomPaint(
            painter: _PongPainter(
              paddlePosition: paddlePosition,
              ball: ball,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-90,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHighScore() {
    return ValueListenableBuilder(
      valueListenable: highScoreNotifier,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Text("HIGHEST SCORE: ${value.toString()}", 
            style: GoogleFonts.inter(
              fontSize: 15,
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.w800
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
            style: GoogleFonts.inter(
              fontSize: 135,
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.w900
            )
          ),
        );
      },
    );
  }

  void _checkCollisions() {

    final paddleTop = 
    MediaQuery.of(context).size.height - (
      _Specification.paddleCollisionHeight + _Specification.paddleYOffset
    );

    if (ball.y + ball.radius >= paddleTop &&
      ball.x >= paddlePositionNotifier.value &&
      ball.x <= paddlePositionNotifier.value + _Specification.paddleWidth &&
      ball.y - ball.radius <= paddleTop + 10) {
    
      if (!hasBounced) {

        scoreNotifier.value++;
        highScore = scoreNotifier.value;
        ball.dy = -ball.dy;

        if (scoreNotifier.value <= 12) {
          ball.dx *= 1.05;
          ball.dy *= 1.05;
        }

        hasBounced = true; 
        
      }

    } else {
      hasBounced = false; 
    }

    if (ball.x - ball.radius <= 0 || ball.x + ball.radius >= MediaQuery.of(context).size.width) {
      ball.dx = -ball.dx;
    }

    if (ball.y - ball.radius <= 0) {
      ball.dy = -ball.dy;
    }

    if (ball.y + ball.radius >= MediaQuery.of(context).size.height - 90) {
      highScoresList.add(highScore);
      highScoreNotifier.value = highScoresList.reduce((score, next) => score > next ? score : next);
      _resetBall();
    }

  }

  void _resetBall() {

    ball.x = _Specification.ballXPosition;
    ball.y = _Specification.ballYPosition;

    ball.dx = _Specification.ballXShootDirection;
    ball.dy = _Specification.ballYShootDirection; 
    
    highScore = scoreNotifier.value;
    scoreNotifier.value = 0;

  }

  void _startGameLoop() {

    tickerTimer = createTicker((elapsed) {
      setState(() {
        ball.updatePosition();
        _checkCollisions();
      });
    });

    tickerTimer.start();

  }

  @override 
  void initState() {
    super.initState();
    _startGameLoop();
  }

  @override
  void dispose() {
    highScoreNotifier.dispose();
    scoreNotifier.dispose();
    paddlePositionNotifier.dispose();
    tickerTimer.dispose();
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