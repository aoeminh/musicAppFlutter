import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecorateIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color decorationColor;
  final VoidCallback onPress;

  DecorateIconButton(
      {this.icon, this.iconColor, this.decorationColor, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Ink(
          child: IconButton(
            icon: Icon(
              icon,
              color: iconColor,
            ),
            onPressed: onPress,
          ),
          decoration:
              ShapeDecoration(color: decorationColor, shape: CircleBorder()),
        ),
      ),
    );
  }
}
