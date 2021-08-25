import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockpedia/screens/makeOption.dart';
// import 'package:mockpedia/screens/makeQnA.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';
import 'package:mockpedia/widgets/SelectDuration.dart';
import 'package:random_string/random_string.dart';

class MakeMock extends StatefulWidget {
  @override
  _MakeMockState createState() => _MakeMockState();
}

class _MakeMockState extends State<MakeMock> {
  final _formkey = GlobalKey<FormState>();
  String mockName, desc, mockId = randomAlphaNumeric(16);
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  Duration duration = Duration(hours: 0, minutes: 0);
  DatabaseService databaseService = new DatabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController dateController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();

  detailSubmit() {
    try {
      if (_formkey.currentState.validate() &&
          "${selectedDate.toLocal()}".split(' ')[0] !=
              "${DateTime.now().toLocal()}".split(' ')[0] &&
          duration != Duration()) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> mockData = {
          "MockName": mockName,
          "MockId": mockId,
          "MockDesc": desc,
          "MockDate": "${selectedDate.toLocal()}".split(' ')[0],
          "Duration": "$duration",
          "UserId": FirebaseAuth.instance.currentUser.email,
        };
        databaseService.addUserMock(mockData, mockId);
        databaseService.addMockData(mockData, mockId);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => MakeQnA(mockId)));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MakeOPtion(
                      mockId: mockId,
                    )));
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Please write mock title, description\nset mock date and duration"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      print("Hello");
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      print(picked.isBefore(selectedDate));
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  _selectDuration(BuildContext context) async {
    final p = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectDuration();
        });
    if (p != null) {
      setState(() {
        duration = p;
        durationController.text = p.toString().split(".")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text("Make Mock"),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      body: Form(
        key: _formkey,
        child: isLoading
            ? Container(
                color: Color.fromARGB(255, 204, 255, 255),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Mock ID :- ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            mockId,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isEmpty ? "Required" : null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Mock Name",
                          labelText: "Mock Name",
                        ),
                        onChanged: (newText) {
                          mockName = newText;
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
                          hintText: "Discription",
                          labelText: "Discription",
                        ),
                        onChanged: (newText) {
                          desc = newText;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: dateController,
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
                          _selectDate(context);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: durationController,
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
                          _selectDuration(context);
                        },
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          detailSubmit();
                          // Navigator.pushNamed(context, "/MakeQnA");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constants.primaryColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
