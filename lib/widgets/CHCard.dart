
import 'package:flutter/material.dart';

class CHCard extends StatefulWidget {
  CHCard({Key? key}) : super(key: key);

  @override
  _CHCardState createState() => _CHCardState();
}

class _CHCardState extends State<CHCard> {
  int clickedCardIndex = -1; // 클릭된 서브 카드의 인덱스
  List<String> subCardTexts = ['Sub Card 1', 'Sub Card 2', 'Sub Card 3'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainCard(context), // 메인 카드
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    String mainCardText =
    clickedCardIndex != -1 ? '축하합니다' : 'Main Front';

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
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          top: 32.0,
          bottom: 32.0,
        ),
        decoration: BoxDecoration(
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
              style:
              Theme.of(context).textTheme.headline6!.copyWith(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
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
    bool isClickable = clickedCardIndex == -1 || clickedCardIndex == index;
    double scaleFactor = clickedCardIndex == index ? 1.2 : 1.0;
    String subCardText =
    isClickable ? (clickedCardIndex == index ? '50 코인 당첨' : subCardTexts[index]) : '꽝';

    return GestureDetector(
      onTap: isClickable
          ? () {
        // Handle sub card tap
        print('Tapped on Sub Card: ${subCardTexts[index]}');
        _toggleSubCard(index);
      }
          : null,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width * 0.1 * scaleFactor,
        height: MediaQuery.of(context).size.height * 0.1 * scaleFactor,
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isClickable ? Colors.white : Colors.grey.withOpacity(0.5),
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
        child: Center(
          child: Text(
            subCardText,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  void _toggleSubCard(int index) {
    setState(() {
      clickedCardIndex = index;
    });
  }
}