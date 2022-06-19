import 'package:flutter/material.dart';

class Window extends StatelessWidget {
  final Color windowColor;

  const Window({
    Key key,
    @required this.windowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: windowColor,
      ),
    );
  }
}
