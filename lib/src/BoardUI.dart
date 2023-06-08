import 'package:flutter/material.dart';
import 'package:handong_han_bakwi/models/BOARD.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>{
  final int _boardCol=8;
  final int _boardTileCount=40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width*0.8,
          child: _buildBoard(),
        ),
      )
    );
  }
  _buildBoard() => Builder(
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
              child: _buildTile(viewIndex),
              // child: _buildTile(model, viewIndex),
            );
          },
        );
      }
  );

  // _buildTile(model, tileIndex) => LayoutBuilder(
  _buildTile(tileIndex) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
            ]
        );
      }
  );
}
