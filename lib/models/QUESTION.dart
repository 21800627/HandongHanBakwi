
import 'dart:math';

class Question{
  List<String> questionList = [
    'What most surprised you when you first arrived on campus or first started classes at this school?',
    'If I visited your hometown, what local spots would you suggest I see?',
    'What movie do you think everyone should watch?',
    'What are three things on your bucket list?',
    'Who is your inspiration?',
    'If you could change one thing about your past, what would it be?',
    'What is your favorites way to spend a weekend?',
    'What is your favorite thing to do on a rainy day?',
    'Who would you choose if you could have a dinner date with anyone in the world?',
  ];

  String getQuestion(){
    int index = Random().nextInt(questionList.length);
    return questionList[index];
  }
}