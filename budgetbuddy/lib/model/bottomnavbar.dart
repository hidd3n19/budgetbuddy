import 'package:flutter/material.dart';

class GifIcon {
  final String assetPath;
  final String label;

  GifIcon(this.assetPath, this.label);
}

// List of GIF icons
final List<GifIcon> gifIcons = [
  GifIcon('assets/gifs/graph-icon.gif', 'Stats'),
  GifIcon('assets/gifs/icons8-home.gif', 'Home'),
  GifIcon('assets/gifs/icons8-plus.gif', ''),
  GifIcon('assets/gifs/icons8-money-bag.gif', '\$tash'),
  GifIcon('assets/gifs/icons8-user.gif', 'User'),
];

// Function to get an Image widget from GifIcon
Widget getGifImage(GifIcon gifIcon) {
  double width = 24;
  double height = 24;
  EdgeInsetsGeometry margin = const EdgeInsets.symmetric(vertical: 0); // Default margin

  // Increase size and change margin for the specific GifIcon
  if (gifIcon.assetPath == 'assets/gifs/icons8-plus.gif') {
    width = 48; // New width
    height = 48; // New height
    margin = const EdgeInsets.symmetric(vertical: 1); // New margin
  }

  return Container(
    margin: margin,
    child: Image.asset(
      gifIcon.assetPath,
      width: width,
      height: height,
    ),
  );
}