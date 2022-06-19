import 'package:flutter/material.dart';

import 'window.dart';

enum cellMode {
  EMPTY,
  GREEN,
  RED,
}

class Cell extends StatelessWidget {
  final currentCellMode;

  Cell({
    Key key,
    @required this.currentCellMode,
  }) : super(key: key);

  Window _buildWindow() {
    switch (this.currentCellMode) {
      case cellMode.GREEN:
        return Window(
          windowColor: Colors.green[600],
        );
        break;
      case cellMode.RED:
        return Window(
          windowColor: Colors.red[600],
        );
      default:
        return Window(
          windowColor: Colors.black,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 45,
          color: Colors.white,
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: _buildWindow(),
        ))
      ],
    );
  }
}
