import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/screens/PreviewQuestion.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';

GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

class MockPreview extends StatefulWidget {
  final String mockId;

  MockPreview(this.mockId);

  @override
  _MockPreviewState createState() => _MockPreviewState();
}

class _MockPreviewState extends State<MockPreview> {
  QuerySnapshot questionSnapshot;
  bool isLoading = false;
  TextEditingController addQuesController = TextEditingController();
  TextEditingController addOp1Controller = TextEditingController();
  TextEditingController addOp2Controller = TextEditingController();
  TextEditingController addOp3Controller = TextEditingController();
  TextEditingController addOp4Controller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();

  fetchData() {
    databaseService.getMockQuestionData(widget.mockId).then(
      (value) {
        questionSnapshot = value;
        // isLoading = false;
        setState(() {});
      },
    );
  }

  // @override
  // void initState() {
  //   fetchData();
  //   super.initState();
  // }

  validateQuestion() async {
    if (_formkey.currentState.validate()) {
      Map<String, dynamic> questionData = {
        'ques': addQuesController.text,
        'option1': addOp1Controller.text,
        'option2': addOp2Controller.text,
        'option3': addOp3Controller.text,
        'option4': addOp4Controller.text,
      };
      setState(() {
        isLoading = true;
      });
      databaseService.addMockQuestionData(questionData, widget.mockId).then(
        (val) {
          print("Done");
          setState(() {
            // fetchData();
          });
        },
      );
      Navigator.pop(context);
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  addQuestionDialog() {
    isLoading
        ? Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          )
        : showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 204, 255, 255),
                  ),
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: addQuesController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Question",
                              labelText: "Question"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: addOp1Controller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Correct Answer",
                              labelText: "Option1"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: addOp2Controller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Option2",
                              labelText: "Option2"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: addOp3Controller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Option3",
                              labelText: "Option3"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: addOp4Controller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Option4",
                              labelText: "Option4"),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text("Add Question"),
                          onPressed: () {
                            validateQuestion();
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewQuesiton(
                                    question: addQuesController.text,
                                    options: [
                                      addOp1Controller.text,
                                      addOp2Controller.text,
                                      addOp3Controller.text,
                                      addOp4Controller.text
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text("Preview")),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("MockPreview"),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              addQuestionDialog();
            },
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topLeft,
        color: Color.fromARGB(255, 204, 255, 255),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Mock")
              .doc(widget.mockId)
              .collection("Questions")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((documents) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ResultMockPlayTile(
                        options: [
                          documents['option1'],
                          documents['option2'],
                          documents['option3'],
                          documents['option4'],
                        ],
                        question: documents['ques'],
                        docId: documents.id,
                        mockId: widget.mockId,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }).toList(),
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
  final String docId;
  final String mockId;

  const ResultMockPlayTile(
      {Key key, this.options, this.question, this.docId, this.mockId})
      : super(key: key);

  @override
  _ResultMockPlayTileState createState() => _ResultMockPlayTileState();
}

class _ResultMockPlayTileState extends State<ResultMockPlayTile> {
  TextEditingController quesController = TextEditingController();
  TextEditingController op1Controller = TextEditingController();
  TextEditingController op2Controller = TextEditingController();
  TextEditingController op3Controller = TextEditingController();
  TextEditingController op4Controller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    quesController.text = widget.question;
    op1Controller.text = widget.options[0];
    op2Controller.text = widget.options[1];
    op3Controller.text = widget.options[2];
    op4Controller.text = widget.options[3];
    super.initState();
  }

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
            Constants.myBoxShadow(),
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
                "Q - " + quesController.text,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
            ),
            ResultOptionTile(
              option: "A",
              description: op1Controller.text,
            ),
            ResultOptionTile(
              option: "B",
              description: op2Controller.text,
            ),
            ResultOptionTile(
              option: "C",
              description: op3Controller.text,
            ),
            ResultOptionTile(
              option: "D",
              description: op4Controller.text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showMyDialog();
                  },
                  label: Text("Edit"),
                  icon: Icon(Icons.edit),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("Mock")
                        .doc(widget.mockId)
                        .collection("Questions")
                        .doc(widget.docId)
                        .delete()
                        .then((val) {
                      print("Delete");
                      setState(() {});
                    });
                  },
                  label: Text("Delete"),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  validateUpdatedFields() {
    if (_formkey.currentState.validate() &&
        (quesController.text != widget.question ||
            op1Controller.text != widget.options[0] ||
            op2Controller.text != widget.options[1] ||
            op3Controller.text != widget.options[2] ||
            op4Controller.text != widget.options[3])) {
      print("all ok");
      FirebaseFirestore.instance
          .collection("Mock")
          .doc(widget.mockId)
          .collection("Questions")
          .doc(widget.docId)
          .update({
        "ques": quesController.text,
        'option1': op1Controller.text,
        'option2': op2Controller.text,
        'option3': op3Controller.text,
        'option4': op4Controller.text
      });
      Navigator.pop(context);
    } else {
      print("something wrong");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please Update something"),
      ));
    }
  }

  showMyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 204, 255, 255),
              ),
              child: Form(
                key: _formkey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: quesController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Question",
                          labelText: "Question"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: op1Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Option1",
                          labelText: "Option1"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: op2Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Option2",
                          labelText: "Option2"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: op3Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Option3",
                          labelText: "Option3"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: op4Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Option4",
                          labelText: "Option4"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.done),
                      label: Text("Done"),
                      onPressed: () {
                        validateUpdatedFields();
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewQuesiton(
                                question: quesController.text,
                                options: [
                                  op1Controller.text,
                                  op2Controller.text,
                                  op3Controller.text,
                                  op4Controller.text
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text("Preview")),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ResultOptionTile extends StatefulWidget {
  final String option, description;
  ResultOptionTile({
    @required this.option,
    @required this.description,
  });

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
          width: 3.0,
        ),
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
            ),
          ),
          Expanded(
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 20,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
