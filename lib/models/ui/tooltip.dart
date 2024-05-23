
import 'package:flutter/material.dart';

class TooltipPopup extends PopupMenuEntry<int> {

  final String tooltip;
  const TooltipPopup({
    required Key key,
    required this.tooltip,
  }) : super(key: key);

  @override
  bool represents(int? n) => n == 1 || n == -1;

  @override
  TooltipPopupState createState() => TooltipPopupState();

  @override
  double get height => 1;
}

class TooltipPopupState extends State<TooltipPopup> {
  @override
  Widget build(BuildContext context) {
    return getTooltipItem(context, widget.tooltip);
  }
}

void pressedTooltip(BuildContext context) {
  Navigator.pop<int>(context, 0);
}

Widget getTooltipItem(BuildContext context, String tooltip) {
  return GestureDetector(
    onTap: () {
      pressedTooltip(context);
    },
    child: Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        tooltip,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    ),
  );
}

