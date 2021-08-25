import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockpedia/services/constant.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user;
  bool isLoading = false;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 12,
        title: Center(
          child: Text("Dashboard"),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Color.fromARGB(255, 204, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 3),
                          boxShadow: [
                            Constants.myBoxShadow(),
                          ],
                        ),
                        child: Image.network(
                          user.photoURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Hi, " + user.displayName.split(" ")[0],
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      crossAxisCount: 2,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/Profile");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              color: Constants.primaryColor(),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                Constants.myBoxShadow(),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_box_outlined,
                                  color: Colors.white,
                                  size: 40,
                                  semanticLabel: "My Profile",
                                ),
                                Text(
                                  "My Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pop();
                            // Navigator.of(context).pushNamed("/MakeMock");
                            Navigator.of(context).pushNamed("/MyMock");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              color: Constants.primaryColor(),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                Constants.myBoxShadow(),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.white,
                                  size: 40,
                                  semanticLabel: "My Mocks",
                                ),
                                Text(
                                  "My Mock",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pop();
                            Navigator.of(context).pushNamed("/GiveMock");
                          },
                          child: Container(
                            // alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              color: Constants.primaryColor(),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                Constants.myBoxShadow(),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  "Give Mock",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pop();
                            Navigator.of(context).pushNamed("/About");
                          },
                          child: Container(
                            // alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              color: Constants.primaryColor(),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                Constants.myBoxShadow(),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_box_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await GoogleSignIn().signOut().whenComplete(
                          () {
                            Navigator.pushReplacementNamed(
                                context, "/Authenticate");
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Constants.primaryColor(),
                        boxShadow: [
                          Constants.myBoxShadow(),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
      // floatingActionButton: BsFloatButton(),
    );
  }
}
