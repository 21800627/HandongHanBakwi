import 'dart:math';

class CHCQuestion{
  List<Map<String,dynamic>> good=[
    {
      'korean': '오른쪽에 있는 사람의 걸음 수 절반 뺏기',
      'english': 'Steal half the steps of the person to the right.',
    },
    {
      'korean': '왼쪽에 있는 사람의 걸음 수 절반 뺏기',
      'english': 'Steal half the steps of the person to the left.',
    },
    {
      'korean': '현재의 우승자와 걸음수 교환하기',
      'english': 'Swap steps with the current winner.',
    },
    {
      'korean': '다른 플레이어들의 공격을 방어하는 카드',
      'english': 'Defense card that block attacks from other players',
    },
    {
      'korean': '한 사람을 임의로 지목하여 그 사람의 100 걸음을 가져온다.',
      'english': 'Pick a random person and take that person\'s 100 steps.',
    },
    {
      'korean': '원할 때 단 한번 질문을 패스 할 수 있는 카드',
      'english': 'A card that allows you to pass a question only once when you want.',
    },
    {
      'korean': '본인을 제외한 모든 플레이어가 각자 80걸음씩 잃기',
      'english': 'All players except you each lose 80 steps.',
    },
    {
      'korean': '본인이 90 걸음 획득',
      'english': 'You gain 90 steps',
    },
  ];

  List<Map<String, dynamic>> bad = [
    {
      'korean': '한 사람을 임의로 지목하여 그 사람에게 자신의 170 걸음 기부하기',
      'english': 'Pick a random person and donate 170 of your steps to that person.',
    },
    {
      'korean': '왼쪽에 위치한 사람이 200걸음 획득',
      'english': 'The person to the left gains 200 steps',
    },
    {
      'korean': '본인의 걸음수가 0으로 초기화된다.',
      'english': 'Your steps are reset to 0.',
    },
    {
      'korean': '본인을 제외한 모든 플레이어가 각자 100걸음 획득',
      'english': 'All players except yourself take 100 steps each.',
    },
    {
      'korean': '현재의 꼴찌와 걸음수 교환하기',
      'english': 'Swap steps with the current bottom.',
    },
  ];

  List<Map<String,dynamic>> boom=[
    {
      'korean': '꽝',
      'english': 'BOOM',
    }
  ];

  String getRandomCHC() {
    final int randomIndex = Random().nextInt(good.length);

    final Map<String, dynamic> chc = {
      'good': {
        'korean': good[randomIndex]['korean'],
        'english': good[randomIndex]['english'],
      },
      'bad': {
        'korean': bad[randomIndex]['korean'],
        'english': bad[randomIndex]['english'],
      },
      'boom': boom,
    };

    return '찬스카드메세지입니다.';
  }
}



