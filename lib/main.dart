//Tacory Bey
//Anthony Congro

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp()); // main entry point
}

// app bar, scaffold, text
class MyApp extends StatelessWidget {
  // root, constructor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(
        length: 4,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Shapes', 'Smiley', 'Party Emoji', 'Heart'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Emoji App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: BasicShapesPainter(),
                size: Size.infinite,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: SmileyUsingBaseShapesPainter(),
                size: Size.infinite,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: PartyEmojiFromBasePainter(),
                size: Size.infinite,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: HeartFromBaseShapesPainter(),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BasicShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    // Square
    paint.color = Colors.blue.shade400;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 80), width: 70, height: 70),
        Radius.circular(8),
      ),
      paint,
    );

    // Circle with gradient
    final circleCenter = Offset(cx, cy);
    final circlePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.red.shade300, Colors.red.shade800],
      ).createShader(Rect.fromCircle(center: circleCenter, radius: 35));
    canvas.drawCircle(circleCenter, 35, circlePaint);

    // Arc
    final arcPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + 80), width: 70, height: 70),
      0,
      2.3,
      false,
      arcPaint,
    );

    // Rectangle
    paint.color = Colors.orange.shade400;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 160), width: 90, height: 50),
        Radius.circular(12),
      ),
      paint,
    );

    // Oval
    paint.color = Colors.teal.shade400;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 160), width: 90, height: 50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SmileyUsingBaseShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) * 0.35;

    // Face with gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade200, Colors.yellow.shade600],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, facePaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    final eyeDX = r * 0.35, eyeDY = -r * 0.2;
    canvas.drawCircle(Offset(c.dx - eyeDX, c.dy + eyeDY), r * 0.09, eyePaint);
    canvas.drawCircle(Offset(c.dx + eyeDX, c.dy + eyeDY), r * 0.09, eyePaint);

    // Smile
    final smileRect = Rect.fromCircle(
      center: Offset(c.dx, c.dy + r * 0.10),
      radius: r * 0.60,
    );
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(4, r * 0.06)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(smileRect, pi * 0.12, pi * 0.70, false, smilePaint);

    // Cheeks
    final cheekPaint = Paint()..color = Colors.pink.shade200.withOpacity(0.7);
    canvas.drawCircle(Offset(c.dx - r * 0.45, c.dy + r * 0.15), r * 0.12, cheekPaint);
    canvas.drawCircle(Offset(c.dx + r * 0.45, c.dy + r * 0.15), r * 0.12, cheekPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PartyEmojiFromBasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) * 0.35;

    // Confetti
    final rand = Random(42);
    final confettiColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];
    for (int i = 0; i < 80; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final paint = Paint()..color = confettiColors[i % confettiColors.length];
      final s = 4.0 + rand.nextDouble() * 6.0;
      canvas.drawCircle(Offset(x, y), s * 0.5, paint);
    }

    // Face
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade200, Colors.yellow.shade600],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, facePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(3, r * 0.05)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(c.dx - r * 0.38, c.dy - r * 0.20), radius: r * 0.20),
      pi * 0.10,
      pi * 0.55,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(c.dx + r * 0.38, c.dy - r * 0.20), radius: r * 0.20),
      pi * 0.35,
      pi * 0.55,
      false,
      eyePaint,
    );

    // Smile
    final smileRect = Rect.fromCircle(
      center: Offset(c.dx, c.dy + r * 0.18),
      radius: r * 0.70,
    );
    final smilePaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(6, r * 0.07)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(smileRect, pi * 0.10, pi * 0.85, false, smilePaint);

    // Hat
    final hatPath = Path()
      ..moveTo(c.dx, c.dy - r * 1.05)
      ..lineTo(c.dx - r * 0.58, c.dy - r * 0.20)
      ..lineTo(c.dx + r * 0.58, c.dy - r * 0.20)
      ..close();
    canvas.drawPath(hatPath, Paint()..color = Colors.purple.shade400);

    // Hat band
    canvas.drawLine(
      Offset(c.dx - r * 0.48, c.dy - r * 0.24),
      Offset(c.dx + r * 0.48, c.dy - r * 0.24),
      Paint()
        ..color = Colors.white
        ..strokeWidth = max(4, r * 0.06),
    );

    // Hat topper star
    final starPaint = Paint()..color = Colors.yellow.shade600;
    canvas.drawCircle(Offset(c.dx, c.dy - r * 1.12), r * 0.12, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartFromBaseShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.18;
    final lobeY = cy - r * 0.15;

    final leftCenter = Offset(cx - r, lobeY);
    final rightCenter = Offset(cx + r, lobeY);
    final leftRect = Rect.fromCircle(center: leftCenter, radius: r);
    final rightRect = Rect.fromCircle(center: rightCenter, radius: r);

    final topMiddle = Offset(cx, lobeY);
    final leftEdge = Offset(cx - 2 * r, lobeY);
    final rightEdge = Offset(cx + 2 * r, lobeY);
    final bottomTip = Offset(cx, cy + r * 1.25);

    final path = Path()
      ..moveTo(topMiddle.dx, topMiddle.dy)
      ..arcTo(leftRect, 0, -pi, false)
      ..lineTo(bottomTip.dx, bottomTip.dy)
      ..lineTo(rightEdge.dx, rightEdge.dy)
      ..arcTo(rightRect, 0, -pi, false)
      ..close();

    // Gradient fill
    final gradient = LinearGradient(
      colors: [Colors.red.shade300, Colors.red.shade900],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(2, r * 0.06);
    canvas.drawPath(path, strokePaint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: leftCenter, radius: r * 0.7),
      -pi * 0.9,
      pi * 0.4,
      false,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
