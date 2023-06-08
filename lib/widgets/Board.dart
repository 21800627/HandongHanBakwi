import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/BOARD.dart';
import '../models/GAME.dart';

class BoardGameScreenState extends StatelessWidget{

  final int _boardCol=8;
  final int _boardTileCount=40;


  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<Game>(context);
    Board board = dataProvider.board;

    return Builder(
        builder: (context) {
          int boardRow=0; //board row
          int j=0; //calculate board tile view index
          int viewIndex=0;
          int colorValue=0;

          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _boardCol,
            ),
            itemCount: _boardTileCount,
            itemBuilder: (BuildContext context, int index){

              boardRow=(index~/_boardCol)%2;

              if(index==0 || index==_boardTileCount-1) {
                colorValue = 0xffC4DFDF;
              } else {
                colorValue=0xffD2E9E9;
              }
              // if row is odd
              if(boardRow!=0){
                // first tile of the row sets j value as 9
                // j value is decreasing until end of the tile
                // it calculate viewIndex which shows player moves
                if(index%_boardCol==0){
                  j=_boardCol-1;
                }
                else{
                  j=j-2;
                }
                viewIndex = index +j;
              }else{
                viewIndex=index;
              }
              return Card(
                // padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(3),
                color: Color(colorValue),
                elevation: 2,
                child: _buildTile(board, viewIndex),
              );
            },
          );
        }
    );
  }

  _buildTile(board, tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        // Calculate the size of the child widget based on the size of the parent widget
        double childWidth = parentWidth * 0.55;
        double childHeight = parentHeight * 0.55;

        List<Widget> playerWidget = [
          // Positioned(
          //     top: 0, // Position each widget vertically
          //     left: 0, // Position each widget horizontally
          //     child: Container(
          //       width: childWidth,
          //       height: childHeight,
          //       child: CircleAvatar(
          //         backgroundColor: Colors.yellow,
          //         foregroundColor: Colors.black,
          //         child: Text('1'),
          //       ),
          //     ),
          // ),
          Positioned(
              top: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player1.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              top: 0, // Position each widget vertically
              right: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player2.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              bottom: 0, // Position each widget vertically
              left: 0, // Position each widget horizontally
              child: Image.asset(
                'assets/images/player3.png',
                width: childWidth,
                height: childHeight,
              )
          ),
          Positioned(
              bottom: 0, // Position each widget horizontally
              right: 0, // Position each widget vertically
              child: Image.asset(
                'assets/images/player4.png',
                width: childWidth,
                height: childHeight,
              )
          )
        ];

        return Stack(
            children: [
              if(tileIndex==0)
                Center(child: Text('Start', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex==_boardTileCount)
                Center(child: Text('End', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4)))),
              if(tileIndex!=0 && tileIndex!=_boardTileCount)
                Center(
                  child: Text('$tileIndex', style: const TextStyle(fontSize: 15, color: Color(0xffF8F6F4))),
                ),

              //Stack player widget
              for(int i=0; i<4; i++)...[
                if(board.isPlayerOnTileIndex(tileIndex, i))
                  playerWidget[i],
              ]
            ]
        );
      }
  );
}
