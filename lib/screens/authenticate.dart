import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mockpedia/authentication/auth.dart';
import 'package:mockpedia/services/constant.dart';
import 'package:mockpedia/services/databaseService.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  Auth _auth = new Auth();
  bool isLoading = false;

  googleSignIn() async {
    try {
      setState(
        () {
          isLoading = true;
        },
      );
      DatabaseService _databaseService = new DatabaseService();
      UserCredential user = await _auth.signInWithGoogle();
      Map<String, dynamic> data = {
        'Name': user.user.displayName,
        'Email': user.user.email,
        'profilePic': user.user.photoURL,
      };
      Navigator.pushReplacementNamed(context, "/Dashboard");

      await _databaseService.setUserData(data, data['Email']);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer(),
                    Image.asset(
                      "assets/logo.jpg",
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "assets/logIn.png",
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("google");
                        googleSignIn();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .6,
                        height: MediaQuery.of(context).size.height * .05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            Constants.myBoxShadow(),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.google),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "Sign With Google",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
