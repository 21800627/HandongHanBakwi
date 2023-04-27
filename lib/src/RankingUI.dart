import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.5,
                child: RankingList()
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Roll Dice'),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Show Q-Card'),
            ),
          ],
        ),
      ),
    );
  }
}

class RankingList extends StatelessWidget {
  final List<String> entries = <String>['A', 'B', 'C','D','E','F'];
  final List<int> colorCodes = <int>[600, 500, 100,200,300,500];

  RankingList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                for(int i = 0; i<entries.length; i++)...[
                Container(
                  height: 40,
                  color: Colors.amber[colorCodes[i]],
                  child: Center(child: Text('Entry ${entries[i]}')),
                )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

}