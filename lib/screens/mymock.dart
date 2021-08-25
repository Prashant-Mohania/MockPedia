import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mockpedia/screens/preview_qna.dart';
import 'package:mockpedia/screens/response.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:mockpedia/widgets/SelectDuration.dart';
import 'package:share/share.dart';

class MyMock extends StatefulWidget {
  @override
  _MyMockState createState() => _MyMockState();
}

class _MyMockState extends State<MyMock> {
  bool isLoading = false;
  QuerySnapshot querySnapshot;
  String userId = FirebaseAuth.instance.currentUser.email;
  DatabaseService databaseService = new DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController mockNameController = new TextEditingController();
  TextEditingController mockDescController = new TextEditingController();
  TextEditingController mockDateController = new TextEditingController();
  TextEditingController mockDurationController = new TextEditingController();
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    print(1);
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Mocks")
        .get()
        .then((val) {
      querySnapshot = val;
    });
    setState(() {
      isLoading = false;
    });
    print(querySnapshot.docs[0]['MockId']);
  }

  deleteData(mockId) async {
    try {
      setState(
        () {
          isLoading = true;
        },
      );
      databaseService.deleteMockData(mockId);
      setState(
        () {
          isLoading = false;
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  codeCheck() {
    TextEditingController _codeCheckController = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Color.fromARGB(255, 204, 255, 255),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Text(
                        "Enter Code",
                        textScaleFactor: 2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _codeCheckController,
                        validator: (val) {
                          return _codeCheckController.text != "IamPramo"
                              ? "Wrong code"
                              : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Code",
                          hintText: "Code",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed("/MakeMock");
                          }
                        },
                        icon: Icon(Icons.done),
                        label: Text("Done"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Color.fromARGB(255, 204, 255, 255),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
              centerTitle: true,
              title: Text("My Mocks"),
              actions: [
                IconButton(
                  onPressed: () {
                    codeCheck();
                    // Navigator.of(context).pushNamed("/MakeMock");
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 204, 255, 255),
            body: querySnapshot.size == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You not make any mocks",
                          textScaleFactor: 2.0,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: querySnapshot == null ? 0 : querySnapshot.size,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(20),
                          child: Dismissible(
                            key: Key(index.toString()),
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (dir) async {
                              // if (dir == DismissDirection.startToEnd) {
                              final res = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 204, 255, 255),
                                      title: Text(
                                        "Alert",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                          "Are you really want to delete mock"),
                                      actions: [
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.done),
                                          label: Text("Yes"),
                                          onPressed: () {
                                            deleteData(querySnapshot.docs[index]
                                                ['MockId']);
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.close),
                                          label: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Swipe to delete",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textScaleFactor: 1.3,
                                  ),
                                ],
                              ),
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyResponse(
                                      mockid: querySnapshot.docs[index]
                                          ['MockId'],
                                    ),
                                  ),
                                );
                              },
                              onTap: () {
                                showBottomSheet(
                                  context,
                                  querySnapshot.docs[index]['MockName'],
                                  querySnapshot.docs[index]['MockDesc'],
                                  querySnapshot.docs[index]['MockId'],
                                  querySnapshot.docs[index]['MockDate'],
                                  querySnapshot.docs[index]['Duration'],
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      Constants.myBoxShadow(),
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                ['MockName'],
                                            textScaleFactor: 1.5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(querySnapshot.docs[index]
                                              ['MockId']),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Share.share(querySnapshot.docs[index]
                                            ['MockId']);
                                      },
                                      icon: Icon(Icons.share),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: querySnapshot.docs[index]
                                                ['MockId']));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Copy to clipboard"),
                                        ));
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
  }

  _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      print(picked.isBefore(selectedDate));
      setState(() {
        mockDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  _selectDuration(BuildContext context, Duration duration) async {
    final p = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectDuration();
        });
    if (p != null) {
      setState(() {
        duration = p;
        mockDurationController.text = p.toString().split(".")[0];
      });
    }
  }

  Widget _mockEditTab(DateTime selectedDate, Duration duration, String mockId,
      String mockName, String mockDesc) {
    // return Container();
    return Form(
      child: ListView(
        padding: EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          TextFormField(
            controller: mockNameController,
            validator: (value) {
              return value.isEmpty ? "Required" : null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Mock Name",
              labelText: "Mock Name",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: mockDescController,
            validator: (value) {
              return value.isEmpty ? "Required" : null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Discription",
              labelText: "Discription",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: mockDateController,
            validator: (value) {
              return value.isEmpty ? "Required" : null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Select Date",
              labelText: "Select Date",
            ),
            readOnly: true,
            onTap: () {
              _selectDate(context, selectedDate);
            },
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: mockDurationController,
            validator: (value) {
              return value.isEmpty ? "Required" : null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Select Duration",
              labelText: "Select Duration",
            ),
            readOnly: true,
            onTap: () {
              _selectDuration(context, duration);
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (mockName != mockNameController.text ||
                  mockDesc != mockDescController.text ||
                  selectedDate.toString().split(" ")[0] !=
                      mockDateController.text ||
                  duration.toString().split(".")[0] !=
                      mockDurationController.text) {
                FirebaseFirestore.instance
                    .collection("Mock")
                    .doc(mockId)
                    .update({
                  "MockName": mockNameController.text,
                  'MockDesc': mockDescController.text,
                  'MockDate': mockDateController.text,
                  'Duration': mockDurationController.text
                });

                FirebaseFirestore.instance
                    .collection("User")
                    .doc(FirebaseAuth.instance.currentUser.email)
                    .collection("Mocks")
                    .doc(mockId)
                    .update({
                  "MockName": mockNameController.text,
                  'MockDesc': mockDescController.text,
                  'MockDate': mockDateController.text,
                  'Duration': mockDurationController.text
                });
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                print("Ok");
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: Text("Update details"),
          ),
        ],
      ),
    );
  }

  Widget ewai() {
    return Container(
      child: Text("Prashant Mohania"),
    );
  }

  showBottomSheet(BuildContext context, String mockName, String mockDesc,
      String mockId, String mockDate, String mockDuration) {
    mockNameController.text = mockName;
    mockDescController.text = mockDesc;
    mockDateController.text = mockDate;
    mockDurationController.text = mockDuration;
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 204, 255, 255),
                // border: Border.all(color: Colors.red, width: 2),
              ),
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Mock Name :-",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          mockName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Mock Description :-",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          mockDesc,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Mock Id :-",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        mockId,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "MockDate :-",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        mockDate,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "MockDuration :-",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        mockDuration,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(Duration(
                        hours: int.parse(mockDuration.toString().split(":")[0]),
                        minutes:
                            int.tryParse(mockDuration.toString().split(":")[1]),
                      ));
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor:
                                  Color.fromARGB(255, 204, 255, 255),
                              child: _mockEditTab(
                                DateTime.parse(mockDate),
                                Duration(
                                    hours: int.tryParse(
                                      mockDuration.toString().split(":")[0],
                                    ),
                                    minutes: int.tryParse(
                                      mockDuration.toString().split(":")[1],
                                    )),
                                mockId,
                                mockName,
                                mockDesc,
                              ),
                            );
                          });
                    },
                    child: Text("Edit Mock Details"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List _questionMock = [];
                      await databaseService
                          .getMockQuestionData(mockId)
                          .then((QuerySnapshot questionSnapshots) {
                        // print(questionSnapshots.docs[0].id);
                        for (int i = 0;
                            i < questionSnapshots.docs.length;
                            i++) {
                          _questionMock.add(
                            {
                              'question': questionSnapshots.docs[i]['ques'],
                              'options': [
                                questionSnapshots.docs[i]['option1'],
                                questionSnapshots.docs[i]['option2'],
                                questionSnapshots.docs[i]['option3'],
                                questionSnapshots.docs[i]['option4']
                              ],
                              'docId': questionSnapshots.docs[i].id
                            },
                          );
                        }
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MockPreview(mockId),
                        ),
                      );
                    },
                    child: Text("Edit Mock Questions"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
