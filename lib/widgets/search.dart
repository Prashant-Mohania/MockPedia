import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mockpedia/screens/qna.dart';
import 'package:mockpedia/services/constant.dart';

class Search extends SearchDelegate {
  final QuerySnapshot mockList;

  Search(this.mockList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Constants.primaryColor(),
      brightness: Brightness.dark,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

    void onPressMockContainer(String mockName, String mockId, String userId,
        String mockDate, String mockDuration) async {
      DateTime date = DateTime.parse(mockDate.toString());
      Duration duration = Duration(
          hours: int.parse("$mockDuration".split(":")[0]),
          minutes: int.parse("$mockDuration".split(":")[1]));
      if ("$date".split(' ')[0] == "${DateTime.now()}".split(' ')[0]) {
        QuerySnapshot res;
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .collection("Mocks")
            .doc(mockId)
            .collection("Response")
            .get()
            .then((val) {
          res = val;
        });
        if (res.docs.length != 0) {
          print(1);
          for (int i = 0; i < res.docs.length; i++) {
            if (res.docs[i].id ==
                FirebaseAuth.instance.currentUser.email.toString()) {
              print(res.docs[i].id.toString() + " Prashant");
              print(2);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("You already give this mock"),
                ),
              );
              return;
            }
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QnA(
                mockName,
                mockId,
                duration,
                userId,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QnA(
                mockName,
                mockId,
                duration,
                userId,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You give this Mock on $mockDate"),
          ),
        );
      }
    }

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      body: mockList != null
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: mockList != null ? mockList.docs.length : 0,
              itemBuilder: (context, index) {
                return query == mockList.docs[index]['MockId']
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: () {
                            onPressMockContainer(
                              mockList.docs[index]['MockName'],
                              mockList.docs[index]['MockId'],
                              mockList.docs[index]['UserId'],
                              mockList.docs[index]['MockDate'],
                              mockList.docs[index]['Duration'],
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  Constants.myBoxShadow(),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Mock Name :-    ",
                                      style: TextStyle(color: Colors.black),
                                      textScaleFactor: 1.3,
                                    ),
                                    Expanded(
                                      child: Text(
                                        mockList.docs[index]['MockName'],
                                        style: TextStyle(color: Colors.black),
                                        textScaleFactor: 1.5,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Description :-    ",
                                      style: TextStyle(color: Colors.black),
                                      textScaleFactor: 1.3,
                                    ),
                                    Expanded(
                                      child: Text(
                                        mockList.docs[index]['MockDesc'],
                                        style: TextStyle(color: Colors.black),
                                        textScaleFactor: 1.5,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Duration :-    ",
                                      style: TextStyle(color: Colors.black),
                                      textScaleFactor: 1.3,
                                    ),
                                    Expanded(
                                      child: Text(
                                        mockList.docs[index]['Duration'],
                                        style: TextStyle(color: Colors.black),
                                        textScaleFactor: 1.5,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        child: index == mockList.size
                            ? Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/no_data.png"),
                                    Text(
                                      "No Mock Found",
                                      textScaleFactor: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      );
              },
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/no_data.png"),
                  Text(
                    "No Mock Found",
                    textScaleFactor: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 204, 255, 255),
    );
  }
}
