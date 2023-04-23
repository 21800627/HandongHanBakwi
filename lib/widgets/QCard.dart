import 'package:flutter/material.dart';
import 'dart:math';

class QCard extends StatefulWidget {
  const QCard({super.key, required this.msg});

  final String msg;

  @override
  State<QCard> createState() => _QCardPageState();
}

class _QCardPageState extends State<QCard> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..rotateX(pi * _animation.value),
      child: GestureDetector(
        onTap: () {
          if (_status == AnimationStatus.dismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }},
        child: Card(
          shape: RoundedRectangleBorder(  //모서리를 둥글게 하기 위해 사용
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0, //그림자 깊이
          child: _animation.value <= 0.5
              ? Container(
              color: Colors.white70,
              width: 300,
              height: 200,
              child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(fontSize: 100, color: Colors.grey),
                  )))
              : Container(
              width: 300,
              height: 200,
              color: Colors.black12,
              child: Center(
                child: RotatedBox(
                    quarterTurns: 2,
                    child: Text(widget.msg)
                ),
              )),
        ),
      ),
    );
  }
}