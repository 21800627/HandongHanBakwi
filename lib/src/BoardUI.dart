import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
      ),
      body: Wrap(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            // height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(10.0),
            child: StaggeredGrid.count(
              crossAxisCount: 10,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: [
                for(int i = 0; i<28; i++)...[
                  // board center
                  if (i==11)
                    const StaggeredGridTile.count(
                      crossAxisCellCount: 8,
                      mainAxisCellCount: 4,
                      child: Tile(index: 11,backgroundColor: Colors.orangeAccent,),
                    ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: Tile(index: i,bottomSpace: 10,),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;

    final child = Container(
      color: backgroundColor ?? _defaultColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
