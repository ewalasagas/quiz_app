import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/quiz': (context) => Quizzler(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Quizzler!',
              style: TextStyle(
                fontFamily: 'Bangers',
                fontSize: 40.0,
                color: Colors.white,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Container(
                margin: new EdgeInsets.all(40.0),
                child: Text(
                  'This a 13 question true or false quiz. Click on the button below to start. At the end you will see your score.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(
                height: 20.0,
                width: 150.0,
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text('Begin Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Icon>scoreKeeper = [];
  int score = 0;

  void checkAnswer(bool userPickedAnswer) {

    bool correctAnswer = quizBrain.getQuestionAnswer();

    setState(() {
      if(quizBrain.isFinished() == true) {
        Alert(
            context: context,
            title: 'Finished!',
            desc: 'You\'ve reached the end of the quiz.',
        ).show();

        Alert(
          context: context,
          title: 'Total Points',
          desc: 'Last question was true! You scored $score points!',
        ).show();
        quizBrain.reset();
        scoreKeeper = [];
      }
      else {
        if (userPickedAnswer == correctAnswer) {
          score++;
          scoreKeeper.add(
              Icon(
                Icons.check,
                color: Colors.green,
              ));
        } else {
          scoreKeeper.add(
              Icon(
                Icons.close,
                color: Colors.red,
              ));
        }
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
