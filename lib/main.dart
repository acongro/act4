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
      // grab all common features with theme, navigate, title
      home: DefaultTabController(
        length: 4, // how many tabs
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
    // lifecycle
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this, // makes animation run smooth
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    // used whenever you move, only load one tab at a time
    _tabController.dispose(); // release all resources, prevent memory leaks
    tabIndex.dispose();
    super.dispose(); // ref parent class
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Shapes', 'Smiley', 'Party Emoji', 'Heart'];

    return Scaffold(
      // standard layout for screen
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Emoji App'),
        bottom: TabBar(
          controller: _tabController, // highlight active tab
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ---- TAB 1: Basic Shapes Demo ----
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: BasicShapesPainter(),
                size: Size.infinite,
              ),
            ),
          ),

          // ---- TAB 2: Smiley Face (compose from base shapes) ----
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: SmileyUsingBaseShapesPainter(),
                size: Size.infinite,
              ),
            ),
          ),

          // ---- TAB 3: Party Emoji (hat + confetti) ----
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: PartyEmojiFromBasePainter(),
                size: Size.infinite,
              ),
            ),
          ),

          // ---- TAB 4: Heart (two circles + triangle path) ----
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

    final squareOffset = Offset(cx, cy + 80);
    final circleOffset = Offset(cx, cy);
    final arcOffset = Offset(cx, cy + 80);
    final rectOffset = Offset(cx, cy - 160);
    final ovalOffset = Offset(cx, cy + 160);

    // Square
    canvas.drawRect(
      Rect.fromCenter(center: squareOffset, width: 60, height: 60),
      Paint()..color = Colors.blue,
    );

    // Circle
    canvas.drawCircle(circleOffset, 30, Paint()..color = Colors.red);

    // Arc
    final arcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
      Rect.fromCenter(center: arcOffset, width: 60, height: 60),
      0,
      2.2,
      false,
      arcPaint,
    );

    // Rectangle
    canvas.drawRect(
      Rect.fromCenter(center: rectOffset, width: 80, height: 40),
      Paint()..color = Colors.orange,
    );

    // Oval
    canvas.drawOval(
      Rect.fromCenter(center: ovalOffset, width: 80, height: 40),
      Paint()..color = Colors.teal,
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

    // Face
    final facePaint = Paint()..color = const Color(0xFFFFEB3B);
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
