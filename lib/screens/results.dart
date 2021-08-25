import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/screens/qna.dart';

int correct = 0;
int wrong = 0;
int notAnswered = 0;
int total;

// ignore: must_be_immutable
class Results extends StatefulWidget {
  // final List userSelectOption;
  // final List mockQuestionOption;
  List userSelectOption;
  List mockQuestionOption;
  final String userId, mockId;
  Results(
      this.userSelectOption, this.mockQuestionOption, this.userId, this.mockId);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  bool isLoading = false;
  @override
  void initState() {
    total = userSelectOption.length;
    for (int i = 0; i < mockQuestionOption.length; i++) {
      if (userSelectOption[i] == null) {
        notAnswered++;
      } else if (userSelectOption[i] == mockQuestionOption[i]['correct']) {
        correct++;
      } else {
        wrong++;
      }
    }
    sendUserResponse();
    print("${widget.userId}, ${widget.mockId}");
    super.initState();
  }

  void sendUserResponse() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userId)
        .collection("Mocks")
        .doc(widget.mockId)
        .collection("Response")
        .doc(FirebaseAuth.instance.currentUser.email)
        .set({
      "StudentName": FirebaseAuth.instance.currentUser.displayName,
      "Total": total,
      "Correct": correct,
      "Wrong": wrong,
      "NotAttempted": notAnswered,
    }).then((val) {
      setState(() {
        isLoading = false;
      });
      print("Done");
    });
  }

  @override
  void dispose() {
    userSelectOption = [];
    mockQuestionOption = [];
    correct = 0;
    wrong = 0;
    notAnswered = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Results"),
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : Container(
              alignment: Alignment.topLeft,
              color: Color.fromARGB(255, 204, 255, 255),
              child: ListView.builder(
                itemCount: widget.userSelectOption.length + 1,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        index == 0
                            ? ResultWidget()
                            : ResultMockPlayTile(
                                widget.mockQuestionOption[index - 1]['options'],
                                widget.mockQuestionOption[index - 1]
                                    ['question'],
                                widget.mockQuestionOption[index - 1]['correct'],
                                widget.userSelectOption[index - 1],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ResultMockPlayTile extends StatefulWidget {
  final List options;
  final String question;
  final String correctOption;
  final String userOptionSelected;
  ResultMockPlayTile(
      this.options, this.question, this.correctOption, this.userOptionSelected);

  @override
  _ResultMockPlayTileState createState() => _ResultMockPlayTileState();
}

class _ResultMockPlayTileState extends State<ResultMockPlayTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
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
                "Q - " + widget.question,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
            ),
            ResultOptionTile(
              option: "A",
              description: widget.options[0],
              correctAnswer: widget.correctOption,
              optionSelected: widget.userOptionSelected,
            ),
            ResultOptionTile(
              option: "B",
              description: widget.options[1],
              correctAnswer: widget.correctOption,
              optionSelected: widget.userOptionSelected,
            ),
            ResultOptionTile(
              option: "C",
              description: widget.options[2],
              correctAnswer: widget.correctOption,
              optionSelected: widget.userOptionSelected,
            ),
            ResultOptionTile(
              option: "D",
              description: widget.options[3],
              correctAnswer: widget.correctOption,
              optionSelected: widget.userOptionSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class ResultOptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  ResultOptionTile(
      {@required this.option,
      @required this.description,
      @required this.correctAnswer,
      @required this.optionSelected});

  @override
  _ResultOptionTileState createState() => _ResultOptionTileState();
}

class _ResultOptionTileState extends State<ResultOptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.optionSelected != widget.description
              ? Colors.black.withOpacity(0.8)
              : widget.optionSelected == widget.correctAnswer
                  ? Colors.green
                  : Colors.red.withOpacity(0.8),
          width: 3.0,
        ),
        color: widget.optionSelected == widget.description
            ? widget.optionSelected == widget.correctAnswer
                ? Colors.green.withOpacity(0.8)
                : Colors.red.withOpacity(0.8)
            : widget.description == widget.correctAnswer
                ? Colors.green.withOpacity(0.8)
                : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.option + " :- ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.optionSelected == widget.description
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.8),
            ),
          ),
          // SizedBox(
          //   width: 20,
          // ),
          Expanded(
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 20,
                color: widget.optionSelected == widget.description
                    ? Colors.white.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Total Question : ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                total.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Correct Answers: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                correct.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Wromg Answers: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                wrong.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Not Answers: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                notAnswered.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
