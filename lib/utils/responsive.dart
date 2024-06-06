import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  final double _width;
  final double _height;
  final double _diagonal;
  final bool _isTablet;

  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get IsTablet => _isTablet;

  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context)
      : _width = MediaQuery.of(context).size.width,
        _height = MediaQuery.of(context).size.height,
        _diagonal = math.sqrt(math.pow(MediaQuery.of(context).size.width, 2) +
            math.pow(MediaQuery.of(context).size.height, 2)),
        _isTablet = MediaQuery.of(context).size.shortestSide >= 600;

  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;
}
