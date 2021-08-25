import 'package:mockpedia/screens/PreviewQuestion.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:flutter/material.dart';

class MakeQnA extends StatefulWidget {
  final String mockId;

  MakeQnA(this.mockId);

  @override
  _MakeQnAState createState() => _MakeQnAState();
}

class _MakeQnAState extends State<MakeQnA> {
  final _formkey = GlobalKey<FormState>();
  String ques, op1, op2, op3, op4;
  bool isLoading = false;
  DatabaseService databaseService = new DatabaseService();

  submit() {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> questionMap = {
        "ques": ques,
        "option1": op1,
        "option2": op2,
        "option3": op3,
        "option4": op4
      };
      databaseService
          .addMockQuestionData(questionMap, widget.mockId)
          .then((value) {
        ques = "";
        op1 = "";
        op2 = "";
        op3 = "";
        op4 = "";
        setState(() {
          isLoading = false;
        });
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  addQuestion() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> questionMap = {
        "ques": ques,
        "option1": op1,
        "option2": op2,
        "option3": op3,
        "option4": op4
      };
      databaseService
          .addMockQuestionData(questionMap, widget.mockId)
          .then((value) {
        ques = "";
        op1 = "";
        op2 = "";
        op3 = "";
        op4 = "";
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<bool> _willPopCallback() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 204, 255, 255),
          title: Text("Alert"),
          content: Text("If you exit now then you lost this mock"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);

                await databaseService.deleteMockData(widget.mockId);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Question Answer"),
      ),
      body: Form(
        key: _formkey,
        onWillPop: _willPopCallback,
        child: isLoading
            ? Container(
                color: Color.fromARGB(255, 204, 255, 255),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                padding: EdgeInsets.all(25),
                color: Color.fromARGB(255, 204, 255, 255),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty ? "Required" : null;
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Question",
                            labelText: "Question",
                          ),
                          onChanged: (newText) {
                            ques = newText;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty ? "Required" : null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Option 1 (Correct Answer)",
                            labelText: "Option 1 (Correct Answer)",
                          ),
                          onChanged: (newText) {
                            op1 = newText;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty ? "Required" : null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Option 2",
                            labelText: "Option 2",
                          ),
                          onChanged: (newText) {
                            op2 = newText;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty ? "Required" : null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Option 3",
                            labelText: "Option 3",
                          ),
                          onChanged: (newText) {
                            op3 = newText;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty ? "Required" : null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Option 4",
                            labelText: "Option 4",
                          ),
                          onChanged: (newText) {
                            op4 = newText;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.pop(context);
                                submit();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor(),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                addQuestion();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor(),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    "Add Question",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewQuesiton(
                                  question: ques,
                                  options: [op1, op2, op3, op4],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Preview",
                            textScaleFactor: 2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
