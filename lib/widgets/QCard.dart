import 'package:flutter/material.dart';

class QCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;

  QCard({required this.frontWidget, required this.backWidget});

  @override
  _QCardState createState() => _QCardState();
}

class _QCardState extends State<QCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _frontAnimation;
  late Animation<double> _backAnimation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _frontAnimation = Tween<double>(begin: 0, end: -180).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _backAnimation = Tween<double>(begin: 180, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isFrontVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
        _isFrontVisible = !_isFrontVisible;
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_isFrontVisible ? _frontAnimation.value : _backAnimation.value),
        alignment: Alignment.center,
        child: _isFrontVisible ? widget.frontWidget : widget.backWidget,
      ),
    );
  }
}

