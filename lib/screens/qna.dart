import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/models/questionmodel.dart';
import 'package:mockpedia/screens/results.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:mockpedia/widgets/playmockWidget.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

List userSelectOption;
List mockQuestionOption = [];

class QnA extends StatefulWidget {
  final String mockName, mockId, userId;
  final Duration duration;
  QnA(this.mockName, this.mockId, this.duration, this.userId);

  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  bool isLoading = true;
  QuerySnapshot questionSnapshot;
  DatabaseService databaseService = new DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  QuestionModel getQuestionModelFromDatasnapshot(
      String ques, List<String> options) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = ques;
    questionModel.correctOption = options[0];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    mockQuestionOption.add(
      {
        "question": ques,
        "options": options,
        "correct": questionModel.correctOption
      },
    );
    return questionModel;
  }

  @override
  void initState() {
    databaseService.getMockQuestionData(widget.mockId).then(
      (value) {
        questionSnapshot = value;
        // userSelectOption = new List(questionSnapshot.docs.length);
        userSelectOption =
            new List.generate(questionSnapshot.docs.length, (index) => null);
        isLoading = false;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "${widget.mockName}",
          style: TextStyle(fontSize: 25),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black54,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(255, 204, 255, 255),
                title: Text("Alert"),
                content: Text("Do you want to submit the mock?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx, false);
                    },
                    child: Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },
                    child: Text("Yes"),
                  )
                ],
              );
            },
          ).then(
            (exit) {
              if (exit == null) return;
              if (exit) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Results(
                      userSelectOption,
                      mockQuestionOption,
                      widget.userId,
                      widget.mockId,
                    ),
                  ),
                );
              }
            },
          );
        },
        child: Icon(Icons.check),
        tooltip: "Submit",
      ),
      body: isLoading
          ? Container(
              color: Color.fromARGB(255, 204, 255, 255),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Color.fromARGB(255, 204, 255, 255),
              child: questionSnapshot.docs == null
                  ? Container(
                      child: Center(
                        child: Text("No Mock Data"),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          // height: 25,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: SlideCountdownClock(
                              duration: widget.duration,
                              slideDirection: SlideDirection.Up,
                              separator: "-",
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              separatorTextStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Constants.primaryColor(),
                                  shape: BoxShape.circle),
                              onDone: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Results(
                                      userSelectOption,
                                      mockQuestionOption,
                                      widget.userId,
                                      widget.mockId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: questionSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MockPlayTile(
                                      getQuestionModelFromDatasnapshot(
                                        questionSnapshot.docs[index]['ques'],
                                        [
                                          questionSnapshot.docs[index]
                                              ['option1'],
                                          questionSnapshot.docs[index]
                                              ['option2'],
                                          questionSnapshot.docs[index]
                                              ['option3'],
                                          questionSnapshot.docs[index]
                                              ['option4']
                                        ],
                                      ),
                                      index),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class MockPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  MockPlayTile(this.questionModel, this.index);

  @override
  _MockPlayTileState createState() => _MockPlayTileState();
}

class _MockPlayTileState extends State<MockPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              "Q ${widget.index + 1} - " + widget.questionModel.question,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                optionSelected = widget.questionModel.option1;
              });
              userSelectOption[widget.index] = optionSelected;
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                optionSelected = widget.questionModel.option2;
              });
              userSelectOption[widget.index] = optionSelected;
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                optionSelected = widget.questionModel.option3;
              });
              userSelectOption[widget.index] = optionSelected;
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                optionSelected = widget.questionModel.option4;
              });
              userSelectOption[widget.index] = optionSelected;
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
        ],
      ),
    );
  }
}
