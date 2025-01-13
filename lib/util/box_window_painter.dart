

import 'package:flutter/material.dart';

class BoxWindowPainter extends CustomPainter {

  bool showTop;
  bool showBottom;

  BoxWindowPainter(
      {
        required this.showTop,
        required this.showBottom,
      }
      );

  @override
  void paint(Canvas canvas, Size size) {
    // always draw the left and right borders by drawing a line from top to bottom,
    // then the top and bottom line borders only if the scroll position is at the top or bottom
    final lineBottomOuter = [Offset(-5, size.height), Offset(size.width+5, size.height)];
    final lineTopOuter = [const Offset(-5, 0), Offset(size.width+5, 0)];
    final lineLeftOuter = [const Offset(0, 0), Offset(0, size.height)];
    final lineRightOuter = [Offset(size.width, 0), Offset(size.width, size.height)];
    final lineLeftShadow = [const Offset(5, 3), Offset(5, size.height-3)];
    final lineRightShadow = [Offset(size.width-5, 3), Offset(size.width-5, size.height-3)];
    final lineBottomShadow = [Offset(3, size.height-5), Offset(size.width-3, size.height-5)];
    final lineTopShadow = [const Offset(3, 5), Offset(size.width-3, 5)];

    final rectBorderInner = Rect.fromLTWH(0, 0, size.width, size.height);

    final borderPaintOuter = Paint()
      ..strokeWidth = 10
      ..color = const Color(0xffa9eccb)
      ..style = PaintingStyle.stroke;
    final borderPaintLine = Paint()
      ..strokeWidth = 4
      ..color = const Color(0xff27a866)
      ..style = PaintingStyle.stroke;
    final borderPaintInner = Paint()
      ..color = const Color(0xff47b8a0)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rectBorderInner, borderPaintInner);
    // canvas.drawRect(rectBorderOuter, borderPaintOuter);
    // canvas.drawRect(rrectShadow, borderPaintLine);
    if (showBottom) {
      canvas.drawLine(lineBottomOuter[0], lineBottomOuter[1], borderPaintOuter);
    }
    if (showTop) {
      canvas.drawLine(lineTopOuter[0], lineTopOuter[1], borderPaintOuter);
    }
    canvas.drawLine(lineLeftOuter[0], lineLeftOuter[1], borderPaintOuter);
    canvas.drawLine(lineRightOuter[0], lineRightOuter[1], borderPaintOuter);

    if (showBottom) {
      canvas.drawLine(lineBottomShadow[0], lineBottomShadow[1], borderPaintLine);
    }
    if (showTop) {
      canvas.drawLine(lineTopShadow[0], lineTopShadow[1], borderPaintLine);
    }
    canvas.drawLine(lineLeftShadow[0], lineLeftShadow[1], borderPaintLine);
    canvas.drawLine(lineRightShadow[0], lineRightShadow[1], borderPaintLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

