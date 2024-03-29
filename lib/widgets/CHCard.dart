

import 'package:flutter/material.dart';

class CHCard extends StatefulWidget {
  //CHCard({Key? key}) : super(key: key);


  String message;
  CHCard({super.key, required this.message});


  @override
  _CHCardState createState() => _CHCardState();
}

class _CHCardState extends State<CHCard> {
  int clickedCardIndex = -1; // 클릭된 서브 카드의 인덱스
  List<String> subCardImages = [
    'assets/images/CHfront1.png',
    'assets/images/CHfront2.png',
    'assets/images/CHfront3.png',
  ];

  List<bool> subCardClickable = [true, true, true]; // 카드 클릭 가능 여부

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMainCard(context), // 메인 카드
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    String mainCardText =
    clickedCardIndex != -1 ? 'Congratulations' : 'Please select a card';
    //clickedCardIndex != -1 ? widget.message : '카드를 선택해주세요';

    return GestureDetector(
      onTap: () {
        if (clickedCardIndex != -1) {
          setState(() {
            clickedCardIndex = -1;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.6,

        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/images/Qback.png'),
          //   fit: BoxFit.fill,
          // ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              mainCardText,
              style: Theme.of(context)
                  .textTheme.headline6!
                  .copyWith(fontSize: 24.0),
            ),
            //SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubCard(context, 0),
                _buildSubCard(context, 1),
                _buildSubCard(context, 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCard(BuildContext context, int index) {
    bool isClickable = subCardClickable[index];
    double scaleFactor = clickedCardIndex == index ? 1.3 : 1.0;
    String subCardImage = subCardImages[index];
    bool isClicked = clickedCardIndex == index;
    String subCardText = isClicked ? '50 코인 당첨' : '';

    return GestureDetector(
      onTap: isClickable
          ? () {
        // Handle sub card tap
        if (!isClicked) {
          print('Tapped on Sub Card: $index');
          _toggleSubCard(index);
        }
      }
          : null,
      child: Stack(
        children: [
          AnimatedContainer(
            width: MediaQuery.of(context).size.width * 0.2 * scaleFactor,
            height: MediaQuery.of(context).size.height * 0.15 * scaleFactor,
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(subCardImage),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          if (isClicked)
            Positioned.fill(
              child: Center(
                child: Text(
                  subCardText,
                  style: TextStyle(
                    color: Colors.black, // Change text color to black
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleSubCard(int index) {
    setState(() {
      // 클릭된 서브 카드의 이미지 변경
      subCardImages[index] = 'assets/images/CHback.png';

      // 클릭된 서브 카드 인덱스 업데이트
      clickedCardIndex = index;

      // 클릭되지 않은 카드 비활성화
      for (int i = 0; i < subCardClickable.length; i++) {
        subCardClickable[i] = (i == index);
      }
    });
  }
}